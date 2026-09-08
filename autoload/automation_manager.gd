extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal auto_crawl_assist_tick(
	work_added: float,
	server_load_added: float
)

signal auto_crawl_assist_level_changed(
	new_level: int
)

signal auto_restart_unlock_changed(
	is_unlocked: bool
)

signal auto_restart_enabled_changed(
	is_enabled: bool
)

signal auto_restart_unlock_earned

signal auto_restart_triggered

signal scheduler_unlock_changed(
	is_unlocked: bool
)

signal scheduler_enabled_changed(
	is_enabled: bool
)

signal scheduler_triggered(
	job_id: StringName
)


# -------------------------------------------------------------------
# Auto Crawl Assist levels
# -------------------------------------------------------------------

const AUTO_ASSIST_MIN_LEVEL: int = 0
const AUTO_ASSIST_MAX_LEVEL: int = 5

const AUTO_ASSIST_UNLOCK_LEVEL: int = 1

const AUTO_ASSIST_INTERVAL_SECONDS: float = 0.50


# -------------------------------------------------------------------
# Auto Crawl Assist balance
#
# Array position = Auto Crawl Assist level.
#
# Level 0 = Locked
# Level 1 = First automation
# Level 5 = Current maximum
# -------------------------------------------------------------------

const AUTO_ASSIST_WORK_PER_SECOND_BY_LEVEL: Array[float] = [
	0.0,
	1.0,
	1.50,
	2.25,
	3.25,
	4.50
]

const AUTO_ASSIST_LOAD_PER_SECOND_BY_LEVEL: Array[float] = [
	0.0,
	0.80,
	1.00,
	1.25,
	1.50,
	1.75
]

# -------------------------------------------------------------------
# Auto-Restart
# -------------------------------------------------------------------

const AUTO_RESTART_DELAY_SECONDS: float = 1.0


# -------------------------------------------------------------------
# Crawl Scheduler
# -------------------------------------------------------------------

const SCHEDULER_DELAY_SECONDS: float = 1.0


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var auto_assist_timer: Timer

var auto_crawl_assist_level: int = (
	AUTO_ASSIST_MIN_LEVEL
)

var auto_restart_timer: Timer

var auto_restart_unlocked: bool = false
var auto_restart_enabled: bool = false

var scheduler_timer: Timer

var scheduler_unlocked: bool = false
var scheduler_enabled: bool = false


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_auto_assist_timer()
	create_auto_restart_timer()
	create_scheduler_timer()

	connect_progression_signals()
	connect_crawler_signals()

	call_deferred(
		"synchronize_auto_assist_with_progression"
	)

	call_deferred(
		"synchronize_scheduler_with_progression"
	)


func create_auto_assist_timer() -> void:
	auto_assist_timer = Timer.new()

	auto_assist_timer.name = (
		"AutoCrawlAssistTimer"
	)

	auto_assist_timer.wait_time = (
		AUTO_ASSIST_INTERVAL_SECONDS
	)

	auto_assist_timer.one_shot = false
	auto_assist_timer.autostart = false

	add_child(
		auto_assist_timer
	)

	auto_assist_timer.timeout.connect(
		_on_auto_assist_timer_timeout
	)

	auto_assist_timer.start()
	
func create_auto_restart_timer() -> void:
	auto_restart_timer = Timer.new()

	auto_restart_timer.name = (
		"AutoRestartTimer"
	)

	auto_restart_timer.wait_time = (
		AUTO_RESTART_DELAY_SECONDS
	)

	auto_restart_timer.one_shot = true
	auto_restart_timer.autostart = false

	add_child(
		auto_restart_timer
	)

	auto_restart_timer.timeout.connect(
		_on_auto_restart_timer_timeout
	)
	
func create_scheduler_timer() -> void:
	scheduler_timer = Timer.new()

	scheduler_timer.name = (
		"CrawlSchedulerTimer"
	)

	scheduler_timer.wait_time = (
		SCHEDULER_DELAY_SECONDS
	)

	scheduler_timer.one_shot = true
	scheduler_timer.autostart = false

	add_child(
		scheduler_timer
	)

	scheduler_timer.timeout.connect(
		_on_scheduler_timer_timeout
	)


func connect_progression_signals() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)
		
func connect_crawler_signals() -> void:
	if not CrawlerManager.crawler_recovered_from_overload.is_connected(
		_on_crawler_recovered_from_overload
	):
		CrawlerManager.crawler_recovered_from_overload.connect(
			_on_crawler_recovered_from_overload
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_auto_restart
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_auto_restart
		)
		
	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_scheduler
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_scheduler
		)


func _on_progression_tier_changed(
	new_tier: int
) -> void:
	synchronize_auto_assist_with_progression()
	synchronize_scheduler_with_progression()

	if (
		new_tier
		< ObjectiveManager.PROGRESSION_TIER_2
	):
		reset_auto_restart()


# -------------------------------------------------------------------
# Progression synchronization
# -------------------------------------------------------------------

func synchronize_auto_assist_with_progression() -> void:
	var progression_unlocked: bool = (
		ObjectiveManager
		.is_auto_crawl_assist_unlocked()
	)

	if progression_unlocked:
		if (
			auto_crawl_assist_level
			< AUTO_ASSIST_UNLOCK_LEVEL
		):
			set_auto_assist_level(
				AUTO_ASSIST_UNLOCK_LEVEL
			)

		return

	if (
		auto_crawl_assist_level
		!= AUTO_ASSIST_MIN_LEVEL
	):
		set_auto_assist_level(
			AUTO_ASSIST_MIN_LEVEL
		)
		
func synchronize_scheduler_with_progression() -> void:
	var progression_allows_scheduler: bool = (
		ObjectiveManager.get_current_progression_tier()
		>= ObjectiveManager.PROGRESSION_TIER_2
		and is_auto_restart_unlocked()
	)

	if progression_allows_scheduler:
		unlock_scheduler()
		return

	reset_scheduler()


# -------------------------------------------------------------------
# Level information
# -------------------------------------------------------------------

func get_auto_assist_level() -> int:
	return auto_crawl_assist_level


func get_auto_assist_max_level() -> int:
	return AUTO_ASSIST_MAX_LEVEL


func is_auto_assist_maxed() -> bool:
	return (
		auto_crawl_assist_level
		>= AUTO_ASSIST_MAX_LEVEL
	)


func get_next_auto_assist_level() -> int:
	return mini(
		auto_crawl_assist_level + 1,
		AUTO_ASSIST_MAX_LEVEL
	)


# -------------------------------------------------------------------
# Level changes
# -------------------------------------------------------------------

func set_auto_assist_level(
	new_level: int
) -> bool:
	var safe_level: int = clampi(
		new_level,
		AUTO_ASSIST_MIN_LEVEL,
		AUTO_ASSIST_MAX_LEVEL
	)

	if (
		safe_level > AUTO_ASSIST_MIN_LEVEL
		and not ObjectiveManager
		.is_auto_crawl_assist_unlocked()
	):
		return false

	if safe_level == auto_crawl_assist_level:
		return false

	auto_crawl_assist_level = safe_level

	auto_crawl_assist_level_changed.emit(
		auto_crawl_assist_level
	)

	return true


func increase_auto_assist_level() -> bool:
	if not (
		ObjectiveManager
		.is_auto_crawl_assist_unlocked()
	):
		return false

	if is_auto_assist_maxed():
		return false

	return set_auto_assist_level(
		auto_crawl_assist_level + 1
	)


# -------------------------------------------------------------------
# Unlock / active state
# -------------------------------------------------------------------

func is_auto_assist_unlocked() -> bool:
	return (
		auto_crawl_assist_level
		>= AUTO_ASSIST_UNLOCK_LEVEL
	)


func is_auto_assist_active() -> bool:
	if not is_auto_assist_unlocked():
		return false

	if not GameState.crawler_running:
		return false

	if CrawlerManager.paused_for_overload:
		return false

	if CrawlerManager.is_current_job_complete():
		return false

	return true
	
	
# -------------------------------------------------------------------
# Crawl Scheduler State
# -------------------------------------------------------------------

func is_scheduler_unlocked() -> bool:
	return scheduler_unlocked


func is_scheduler_enabled() -> bool:
	return (
		scheduler_unlocked
		and scheduler_enabled
	)


func unlock_scheduler() -> bool:
	if scheduler_unlocked:
		return false

	if (
		ObjectiveManager.get_current_progression_tier()
		< ObjectiveManager.PROGRESSION_TIER_2
	):
		return false

	if not is_auto_restart_unlocked():
		return false

	scheduler_unlocked = true

	scheduler_unlock_changed.emit(
		true
	)

	return true


func set_scheduler_enabled(
	new_enabled: bool
) -> bool:
	if not scheduler_unlocked:
		return false

	if scheduler_enabled == new_enabled:
		return false

	scheduler_enabled = new_enabled

	if (
		not scheduler_enabled
		and scheduler_timer != null
	):
		scheduler_timer.stop()

	scheduler_enabled_changed.emit(
		scheduler_enabled
	)

	return true
	
	
# -------------------------------------------------------------------
# Auto-Restart State
# -------------------------------------------------------------------

func is_auto_restart_unlocked() -> bool:
	return auto_restart_unlocked


func is_auto_restart_enabled() -> bool:
	return (
		auto_restart_unlocked
		and auto_restart_enabled
	)


func unlock_auto_restart() -> bool:
	if auto_restart_unlocked:
		return false

	if (
		ObjectiveManager.get_current_progression_tier()
		< ObjectiveManager.PROGRESSION_TIER_2
	):
		return false

	auto_restart_unlocked = true
	auto_restart_enabled = true

	auto_restart_unlock_changed.emit(
		true
	)

	auto_restart_enabled_changed.emit(
		true
	)

	auto_restart_unlock_earned.emit()
	
	synchronize_scheduler_with_progression()

	return true


func set_auto_restart_enabled(
	new_enabled: bool
) -> bool:
	if not auto_restart_unlocked:
		return false

	if auto_restart_enabled == new_enabled:
		return false

	auto_restart_enabled = new_enabled

	if (
		not auto_restart_enabled
		and auto_restart_timer != null
	):
		auto_restart_timer.stop()

	auto_restart_enabled_changed.emit(
		auto_restart_enabled
	)

	return true
	
func _on_crawl_job_completed_for_auto_restart() -> void:
	if auto_restart_unlocked:
		return

	if (
		CrawlerManager.get_selected_job_id()
		!= CrawlerManager.CRAWL_JOB_EXPANDED
	):
		return

	unlock_auto_restart()
	
func _on_crawler_recovered_from_overload() -> void:
	if not is_auto_restart_enabled():
		return

	if GameState.crawler_running:
		return

	if CrawlerManager.is_current_job_complete():
		return

	if auto_restart_timer == null:
		return

	auto_restart_timer.stop()
	auto_restart_timer.start()
	
func _on_auto_restart_timer_timeout() -> void:
	if not is_auto_restart_enabled():
		return

	if GameState.crawler_running:
		return

	if CrawlerManager.paused_for_overload:
		return

	if CrawlerManager.is_current_job_complete():
		return

	if (
		GameState.server_load
		>= CrawlerManager.get_effective_recovery_threshold()
	):
		return

	CrawlerManager.start_crawler()

	if GameState.crawler_running:
		auto_restart_triggered.emit()
		
		
# -------------------------------------------------------------------
# Crawl Scheduler Processing
# -------------------------------------------------------------------

func _on_crawl_job_completed_for_scheduler() -> void:
	if not is_scheduler_enabled():
		return

	if not is_auto_restart_unlocked():
		return

	if (
		CrawlerManager.get_crawl_job_queue_size()
		<= 0
	):
		return

	if scheduler_timer == null:
		return

	scheduler_timer.stop()
	scheduler_timer.start()
	
func _on_scheduler_timer_timeout() -> void:
	if not is_scheduler_enabled():
		return

	if not is_auto_restart_unlocked():
		return

	if GameState.crawler_running:
		return

	if CrawlerManager.paused_for_overload:
		return

	if not CrawlerManager.is_current_job_complete():
		return

	if (
		CrawlerManager.get_crawl_job_queue_size()
		<= 0
	):
		return

	if (
		GameState.server_load
		>= CrawlerManager.get_effective_maximum_safe_load()
	):
		scheduler_timer.start()
		return

	var next_job_id: StringName = (
		CrawlerManager.peek_next_queued_crawl_job()
	)

	if next_job_id == &"":
		return

	if not CrawlerManager.is_crawl_job_unlocked(
		next_job_id
	):
		return

	var selection_successful: bool = (
		CrawlerManager.select_crawl_job(
			next_job_id
		)
	)

	if not selection_successful:
		return

	CrawlerManager.start_crawler()

	if not GameState.crawler_running:
		return

	var consumed_job_id: StringName = (
		CrawlerManager.take_next_queued_crawl_job()
	)

	if consumed_job_id != next_job_id:
		return

	scheduler_triggered.emit(
		next_job_id
	)
		
# -------------------------------------------------------------------
# Auto-Restart Save Restore
# -------------------------------------------------------------------

func restore_auto_restart_state(
	saved_unlocked: bool,
	saved_enabled: bool
) -> void:
	var progression_allows_auto_restart: bool = (
		ObjectiveManager.get_current_progression_tier()
		>= ObjectiveManager.PROGRESSION_TIER_2
	)

	var restored_unlocked: bool = (
		saved_unlocked
		and progression_allows_auto_restart
	)

	var restored_enabled: bool = (
		saved_enabled
		and restored_unlocked
	)

	var unlock_changed: bool = (
		auto_restart_unlocked
		!= restored_unlocked
	)

	var enabled_changed: bool = (
		auto_restart_enabled
		!= restored_enabled
	)

	if auto_restart_timer != null:
		auto_restart_timer.stop()

	auto_restart_unlocked = restored_unlocked
	auto_restart_enabled = restored_enabled

	if unlock_changed:
		auto_restart_unlock_changed.emit(
			auto_restart_unlocked
		)

	if enabled_changed:
		auto_restart_enabled_changed.emit(
			auto_restart_enabled
		)
		

# -------------------------------------------------------------------
# Scheduler Save Restore
# -------------------------------------------------------------------

func restore_scheduler_state(
	saved_enabled: bool
) -> void:
	var progression_allows_scheduler: bool = (
		ObjectiveManager.get_current_progression_tier()
		>= ObjectiveManager.PROGRESSION_TIER_2
		and is_auto_restart_unlocked()
	)

	var restored_unlocked: bool = (
		progression_allows_scheduler
	)

	var restored_enabled: bool = (
		saved_enabled
		and restored_unlocked
	)

	var unlock_changed: bool = (
		scheduler_unlocked
		!= restored_unlocked
	)

	var enabled_changed: bool = (
		scheduler_enabled
		!= restored_enabled
	)

	if scheduler_timer != null:
		scheduler_timer.stop()

	scheduler_unlocked = restored_unlocked
	scheduler_enabled = restored_enabled

	if unlock_changed:
		scheduler_unlock_changed.emit(
			scheduler_unlocked
		)

	if enabled_changed:
		scheduler_enabled_changed.emit(
			scheduler_enabled
		)


# -------------------------------------------------------------------
# Level balance information
# -------------------------------------------------------------------

func get_auto_assist_work_per_second_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_ASSIST_MIN_LEVEL,
		AUTO_ASSIST_MAX_LEVEL
	)

	return (
		AUTO_ASSIST_WORK_PER_SECOND_BY_LEVEL[
			safe_level
		]
	)


func get_auto_assist_load_per_second_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_ASSIST_MIN_LEVEL,
		AUTO_ASSIST_MAX_LEVEL
	)

	return (
		AUTO_ASSIST_LOAD_PER_SECOND_BY_LEVEL[
			safe_level
		]
	)


func get_auto_assist_work_per_second() -> float:
	var base_work_per_second: float = (
		get_auto_assist_work_per_second_for_level(
			auto_crawl_assist_level
		)
	)

	return (
		base_work_per_second
		* CrawlerManager.get_priority_crawl_multiplier()
	)


func get_auto_assist_load_per_second() -> float:
	var base_load_per_second: float = (
		get_auto_assist_load_per_second_for_level(
			auto_crawl_assist_level
		)
	)

	return (
		base_load_per_second
		* CrawlerManager.get_priority_load_multiplier()
	)


func get_auto_assist_work_per_tick() -> float:
	return (
		get_auto_assist_work_per_second()
		* AUTO_ASSIST_INTERVAL_SECONDS
	)


func get_auto_assist_load_per_tick() -> float:
	return (
		get_auto_assist_load_per_second()
		* AUTO_ASSIST_INTERVAL_SECONDS
	)


# -------------------------------------------------------------------
# Combined crawler rate
# -------------------------------------------------------------------

func get_effective_total_crawl_rate() -> float:
	var total_rate: float = (
		CrawlerManager.get_effective_automatic_crawl_rate()
	)

	if is_auto_assist_active():
		total_rate += (
			get_auto_assist_work_per_second()
		)

	return total_rate


# -------------------------------------------------------------------
# Processing
# -------------------------------------------------------------------

func _on_auto_assist_timer_timeout() -> void:
	if not is_auto_assist_active():
		return

	var work_amount: float = (
		get_auto_assist_work_per_tick()
	)

	var load_amount: float = (
		get_auto_assist_load_per_tick()
	)

	if work_amount <= 0.0:
		return

	var assist_applied: bool = (
		CrawlerManager.apply_automated_crawl_assist(
			work_amount,
			load_amount
		)
	)

	if not assist_applied:
		return

	auto_crawl_assist_tick.emit(
		work_amount,
		load_amount
	)


# -------------------------------------------------------------------
# New-game reset
# -------------------------------------------------------------------

func reset_automation() -> void:
	set_auto_assist_level(
		AUTO_ASSIST_MIN_LEVEL
	)

	reset_auto_restart()
	reset_scheduler()
	
func reset_auto_restart() -> void:
	if auto_restart_timer != null:
		auto_restart_timer.stop()

	var was_unlocked: bool = (
		auto_restart_unlocked
	)

	var was_enabled: bool = (
		auto_restart_enabled
	)

	auto_restart_unlocked = false
	auto_restart_enabled = false

	if was_unlocked:
		auto_restart_unlock_changed.emit(
			false
		)

	if was_enabled:
		auto_restart_enabled_changed.emit(
			false
		)
		
func reset_scheduler() -> void:
	if scheduler_timer != null:
		scheduler_timer.stop()

	var was_unlocked: bool = (
		scheduler_unlocked
	)

	var was_enabled: bool = (
		scheduler_enabled
	)

	scheduler_unlocked = false
	scheduler_enabled = false

	if was_unlocked:
		scheduler_unlock_changed.emit(
			false
		)

	if was_enabled:
		scheduler_enabled_changed.emit(
			false
		)
