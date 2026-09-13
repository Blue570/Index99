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
# Auto-Throttle Signals
# -------------------------------------------------------------------

signal auto_throttle_unlock_changed(
	is_unlocked: bool
)

signal auto_throttle_level_changed(
	new_level: int
)

signal auto_throttle_enabled_changed(
	is_enabled: bool
)

signal auto_throttle_unlock_earned

signal scheduled_crawl_completed_count_changed(
	new_count: int
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
# Auto-Throttle Progression
# -------------------------------------------------------------------

const AUTO_THROTTLE_MIN_LEVEL: int = 0
const AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL: int = 4

const AUTO_THROTTLE_PROTOTYPE_LEVEL: int = 1

const AUTO_THROTTLE_SCHEDULED_CRAWLS_REQUIRED: int = 3
const AUTO_THROTTLE_MONITOR_INTERVAL_SECONDS: float = 0.10


# -------------------------------------------------------------------
# Auto-Throttle Balance
#
# Array position = Auto-Throttle level.
#
# Maximum cycles:
# -1 = unlimited
# -------------------------------------------------------------------

const AUTO_THROTTLE_MAX_CYCLES_BY_LEVEL: Array[int] = [
	0,
	1,
	2,
	3,
	-1
]

const AUTO_THROTTLE_TRIGGER_PERCENT_BY_LEVEL: Array[float] = [
	0.0,
	90.0,
	90.0,
	90.0,
	88.0
]

const AUTO_THROTTLE_RESUME_PERCENT_BY_LEVEL: Array[float] = [
	0.0,
	45.0,
	45.0,
	50.0,
	55.0
]

const AUTO_THROTTLE_REACTION_DELAY_BY_LEVEL: Array[float] = [
	0.0,
	2.0,
	1.5,
	1.0,
	0.5
]

const AUTO_THROTTLE_COOLDOWN_BY_LEVEL: Array[float] = [
	0.0,
	25.0,
	20.0,
	15.0,
	10.0
]


# -------------------------------------------------------------------
# Auto-Throttle Upgrade Costs
#
# Array position = level being purchased.
#
# Level 1 is earned through gameplay.
# Levels 2-4 require investment.
# -------------------------------------------------------------------

const AUTO_THROTTLE_MONEY_COST_BY_LEVEL: Array[float] = [
	0.0,
	0.0,
	250.0,
	750.0,
	0.0
]

const AUTO_THROTTLE_RESEARCH_COST_BY_LEVEL: Array[float] = [
	0.0,
	0.0,
	0.0,
	10.0,
	25.0
]


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

var auto_throttle_level: int = (
	AUTO_THROTTLE_MIN_LEVEL
)

var auto_throttle_enabled: bool = false

var scheduled_crawls_completed: int = 0

var current_crawl_started_by_scheduler: bool = false

var auto_throttle_monitor_timer: Timer
var auto_throttle_reaction_timer: Timer
var auto_throttle_cooldown_timer: Timer

var auto_throttle_cycles_used: int = 0

var auto_throttle_reaction_pending: bool = false
var auto_throttle_cooldown_active: bool = false


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_auto_assist_timer()
	create_auto_restart_timer()
	create_scheduler_timer()

	connect_progression_signals()
	connect_crawler_signals()
	
	create_auto_throttle_monitor_timer()
	create_auto_throttle_reaction_timer()
	create_auto_throttle_cooldown_timer()

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
	
func create_auto_throttle_monitor_timer() -> void:
	auto_throttle_monitor_timer = Timer.new()

	auto_throttle_monitor_timer.name = (
		"AutoThrottleMonitorTimer"
	)

	auto_throttle_monitor_timer.wait_time = (
		AUTO_THROTTLE_MONITOR_INTERVAL_SECONDS
	)

	auto_throttle_monitor_timer.one_shot = false
	auto_throttle_monitor_timer.autostart = false

	add_child(
		auto_throttle_monitor_timer
	)

	auto_throttle_monitor_timer.timeout.connect(
		_on_auto_throttle_monitor_timer_timeout
	)

	auto_throttle_monitor_timer.start()
	
func create_auto_throttle_reaction_timer() -> void:
	auto_throttle_reaction_timer = Timer.new()

	auto_throttle_reaction_timer.name = (
		"AutoThrottleReactionTimer"
	)

	auto_throttle_reaction_timer.one_shot = true
	auto_throttle_reaction_timer.autostart = false

	add_child(
		auto_throttle_reaction_timer
	)

	auto_throttle_reaction_timer.timeout.connect(
		_on_auto_throttle_reaction_timer_timeout
	)

func create_auto_throttle_cooldown_timer() -> void:
	auto_throttle_cooldown_timer = Timer.new()

	auto_throttle_cooldown_timer.name = (
		"AutoThrottleCooldownTimer"
	)

	auto_throttle_cooldown_timer.one_shot = true
	auto_throttle_cooldown_timer.autostart = false

	add_child(
		auto_throttle_cooldown_timer
	)

	auto_throttle_cooldown_timer.timeout.connect(
		_on_auto_throttle_cooldown_timer_timeout
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
		
	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_auto_throttle_progression
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_auto_throttle_progression
		)
		
	if not CrawlerManager.crawler_state_changed.is_connected(
		_on_crawler_state_changed_for_auto_throttle
	):
		CrawlerManager.crawler_state_changed.connect(
			_on_crawler_state_changed_for_auto_throttle
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_auto_throttle_runtime
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_auto_throttle_runtime
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
		reset_auto_throttle_progression()


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
# Auto-Throttle Level Information
# -------------------------------------------------------------------

func get_auto_throttle_level() -> int:
	return auto_throttle_level


func get_auto_throttle_max_implemented_level() -> int:
	return AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL


func is_auto_throttle_unlocked() -> bool:
	return (
		auto_throttle_level
		>= AUTO_THROTTLE_PROTOTYPE_LEVEL
	)


func is_auto_throttle_enabled() -> bool:
	return (
		is_auto_throttle_unlocked()
		and auto_throttle_enabled
	)
	
func set_auto_throttle_enabled(
	new_enabled: bool
) -> bool:
	if not is_auto_throttle_unlocked():
		return false

	if auto_throttle_enabled == new_enabled:
		return false

	auto_throttle_enabled = new_enabled

	if not auto_throttle_enabled:
		cancel_auto_throttle_reaction()
		stop_auto_throttle_cooldown()

		if CrawlerManager.paused_for_auto_throttle:
			CrawlerManager.resume_crawler_from_auto_throttle()

	auto_throttle_enabled_changed.emit(
		auto_throttle_enabled
	)

	return true
	
func has_auto_throttle_cycle_available() -> bool:
	var maximum_cycles: int = (
		get_auto_throttle_max_cycles()
	)

	if maximum_cycles < 0:
		return true

	return (
		auto_throttle_cycles_used
		< maximum_cycles
	)
	
func cancel_auto_throttle_reaction() -> void:
	if auto_throttle_reaction_timer != null:
		auto_throttle_reaction_timer.stop()

	auto_throttle_reaction_pending = false
	
func start_auto_throttle_cooldown() -> void:
	if auto_throttle_cooldown_timer == null:
		return

	var cooldown_seconds: float = (
		get_auto_throttle_cooldown()
	)

	if cooldown_seconds <= 0.0:
		auto_throttle_cooldown_active = false
		return

	auto_throttle_cooldown_active = true

	auto_throttle_cooldown_timer.stop()
	auto_throttle_cooldown_timer.start(
		cooldown_seconds
	)
	
func stop_auto_throttle_cooldown() -> void:
	if auto_throttle_cooldown_timer != null:
		auto_throttle_cooldown_timer.stop()

	auto_throttle_cooldown_active = false
	
func _on_auto_throttle_monitor_timer_timeout() -> void:
	if not is_auto_throttle_enabled():
		cancel_auto_throttle_reaction()
		return

	if CrawlerManager.paused_for_overload:
		cancel_auto_throttle_reaction()
		return

	if CrawlerManager.is_current_job_complete():
		cancel_auto_throttle_reaction()
		return

	if CrawlerManager.paused_for_auto_throttle:
		cancel_auto_throttle_reaction()

		var current_load_percent: float = (
			CrawlerManager.get_server_load_usage_percent(
				GameState.server_load
			)
		)

		if (
			current_load_percent
			<= get_auto_throttle_resume_percent()
		):
			var resumed: bool = (
				CrawlerManager
				.resume_crawler_from_auto_throttle()
			)

			if resumed:
				start_auto_throttle_cooldown()

				print(
					"Auto-Throttle resumed crawler at %.1f%% load."
					% current_load_percent
				)

		return

	if not GameState.crawler_running:
		cancel_auto_throttle_reaction()
		return

	if auto_throttle_cooldown_active:
		return

	if not has_auto_throttle_cycle_available():
		cancel_auto_throttle_reaction()
		return

	var current_load_percent: float = (
		CrawlerManager.get_server_load_usage_percent(
			GameState.server_load
		)
	)

	var trigger_percent: float = (
		get_auto_throttle_trigger_percent()
	)

	if current_load_percent < trigger_percent:
		cancel_auto_throttle_reaction()
		return

	if auto_throttle_reaction_pending:
		return

	if auto_throttle_reaction_timer == null:
		return

	auto_throttle_reaction_pending = true

	auto_throttle_reaction_timer.stop()
	auto_throttle_reaction_timer.start(
		get_auto_throttle_reaction_delay()
	)

	print(
		"Auto-Throttle reaction started at %.1f%% load."
		% current_load_percent
	)
	
func _on_auto_throttle_reaction_timer_timeout() -> void:
	auto_throttle_reaction_pending = false

	if not is_auto_throttle_enabled():
		return

	if not GameState.crawler_running:
		return

	if CrawlerManager.paused_for_overload:
		return

	if CrawlerManager.paused_for_auto_throttle:
		return

	if CrawlerManager.is_current_job_complete():
		return

	if auto_throttle_cooldown_active:
		return

	if not has_auto_throttle_cycle_available():
		return

	var current_load_percent: float = (
		CrawlerManager.get_server_load_usage_percent(
			GameState.server_load
		)
	)

	if (
		current_load_percent
		< get_auto_throttle_trigger_percent()
	):
		return

	var paused_successfully: bool = (
		CrawlerManager.pause_crawler_for_auto_throttle()
	)

	if not paused_successfully:
		return

	auto_throttle_cycles_used += 1

	print(
		"Auto-Throttle paused crawler. Cycle %d used."
		% auto_throttle_cycles_used
	)
	
func _on_auto_throttle_cooldown_timer_timeout() -> void:
	auto_throttle_cooldown_active = false

	print(
		"Auto-Throttle cooldown complete."
	)
	
func _on_crawler_state_changed_for_auto_throttle(
	is_running: bool
) -> void:
	if is_running:
		return

	if CrawlerManager.paused_for_auto_throttle:
		return

	cancel_auto_throttle_reaction()
	
func _on_crawl_job_completed_for_auto_throttle_runtime() -> void:
	cancel_auto_throttle_reaction()
	stop_auto_throttle_cooldown()

	auto_throttle_cycles_used = 0


func is_auto_throttle_maxed() -> bool:
	return (
		auto_throttle_level
		>= AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)


func get_next_auto_throttle_level() -> int:
	return mini(
		auto_throttle_level + 1,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)
	
func get_auto_throttle_cycles_used() -> int:
	return auto_throttle_cycles_used


func is_auto_throttle_reaction_pending() -> bool:
	return auto_throttle_reaction_pending


func is_auto_throttle_cooldown_active() -> bool:
	return auto_throttle_cooldown_active


func get_scheduled_crawls_completed() -> int:
	return scheduled_crawls_completed


func get_auto_throttle_unlock_requirement() -> int:
	return AUTO_THROTTLE_SCHEDULED_CRAWLS_REQUIRED
	
func get_auto_throttle_max_cycles_for_level(
	level: int
) -> int:
	var safe_level: int = clampi(
		level,
		AUTO_THROTTLE_MIN_LEVEL,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)

	return AUTO_THROTTLE_MAX_CYCLES_BY_LEVEL[
		safe_level
	]


func get_auto_throttle_trigger_percent_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_THROTTLE_MIN_LEVEL,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)

	return AUTO_THROTTLE_TRIGGER_PERCENT_BY_LEVEL[
		safe_level
	]


func get_auto_throttle_resume_percent_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_THROTTLE_MIN_LEVEL,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)

	return AUTO_THROTTLE_RESUME_PERCENT_BY_LEVEL[
		safe_level
	]


func get_auto_throttle_reaction_delay_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_THROTTLE_MIN_LEVEL,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)

	return AUTO_THROTTLE_REACTION_DELAY_BY_LEVEL[
		safe_level
	]


func get_auto_throttle_cooldown_for_level(
	level: int
) -> float:
	var safe_level: int = clampi(
		level,
		AUTO_THROTTLE_MIN_LEVEL,
		AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	)

	return AUTO_THROTTLE_COOLDOWN_BY_LEVEL[
		safe_level
	]
	
func get_auto_throttle_max_cycles() -> int:
	return get_auto_throttle_max_cycles_for_level(
		auto_throttle_level
	)


func get_auto_throttle_trigger_percent() -> float:
	return get_auto_throttle_trigger_percent_for_level(
		auto_throttle_level
	)


func get_auto_throttle_resume_percent() -> float:
	return get_auto_throttle_resume_percent_for_level(
		auto_throttle_level
	)


func get_auto_throttle_reaction_delay() -> float:
	return get_auto_throttle_reaction_delay_for_level(
		auto_throttle_level
	)


func get_auto_throttle_cooldown() -> float:
	return get_auto_throttle_cooldown_for_level(
		auto_throttle_level
	)
	
func get_auto_throttle_money_cost_for_level(
	level: int
) -> float:
	if (
		level < AUTO_THROTTLE_PROTOTYPE_LEVEL
		or level
		> AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	):
		return 0.0

	return AUTO_THROTTLE_MONEY_COST_BY_LEVEL[
		level
	]


func get_auto_throttle_research_cost_for_level(
	level: int
) -> float:
	if (
		level < AUTO_THROTTLE_PROTOTYPE_LEVEL
		or level
		> AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	):
		return 0.0

	return AUTO_THROTTLE_RESEARCH_COST_BY_LEVEL[
		level
	]


func get_next_auto_throttle_money_cost() -> float:
	if is_auto_throttle_maxed():
		return 0.0

	return get_auto_throttle_money_cost_for_level(
		get_next_auto_throttle_level()
	)


func get_next_auto_throttle_research_cost() -> float:
	if is_auto_throttle_maxed():
		return 0.0

	return get_auto_throttle_research_cost_for_level(
		get_next_auto_throttle_level()
	)
	
func get_auto_throttle_level_name(
	level: int
) -> String:
	match level:
		0:
			return "LOCKED"

		1:
			return "PROTOTYPE"

		2:
			return "IMPROVED GOVERNOR"

		3:
			return "LOAD CONTROLLER"

		4:
			return "OPTIMIZED GOVERNOR"

		_:
			return "UNKNOWN"
			
func get_current_auto_throttle_level_name() -> String:
	return get_auto_throttle_level_name(
		auto_throttle_level
	)
	

# -------------------------------------------------------------------
# Auto-Throttle Progression
# -------------------------------------------------------------------

func unlock_auto_throttle_prototype() -> bool:
	if is_auto_throttle_unlocked():
		return false

	if (
		scheduled_crawls_completed
		< AUTO_THROTTLE_SCHEDULED_CRAWLS_REQUIRED
	):
		return false

	auto_throttle_level = (
		AUTO_THROTTLE_PROTOTYPE_LEVEL
	)

	auto_throttle_enabled = false

	auto_throttle_unlock_changed.emit(
		true
	)

	auto_throttle_level_changed.emit(
		auto_throttle_level
	)

	auto_throttle_unlock_earned.emit()
	
	print(
		"Auto-Throttle Prototype unlocked."
	)

	return true


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
# Auto-Throttle Accomplishment Progress
# -------------------------------------------------------------------

func _on_crawl_job_completed_for_auto_throttle_progression() -> void:
	if not current_crawl_started_by_scheduler:
		return

	current_crawl_started_by_scheduler = false

	scheduled_crawls_completed += 1
	
	print(
		"Auto-Throttle progress: %d / %d"
		% [
			scheduled_crawls_completed,
			AUTO_THROTTLE_SCHEDULED_CRAWLS_REQUIRED
		]
	)

	scheduled_crawl_completed_count_changed.emit(
		scheduled_crawls_completed
	)

	if is_auto_throttle_unlocked():
		return

	if (
		scheduled_crawls_completed
		< AUTO_THROTTLE_SCHEDULED_CRAWLS_REQUIRED
	):
		return

	unlock_auto_throttle_prototype()
		
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
		
	current_crawl_started_by_scheduler = true

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
	reset_auto_throttle_progression()
	
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
		
func reset_auto_throttle_progression() -> void:
	var previous_level: int = (
		auto_throttle_level
	)

	var was_unlocked: bool = (
		is_auto_throttle_unlocked()
	)

	var was_enabled: bool = (
		auto_throttle_enabled
	)

	var previous_completed_count: int = (
		scheduled_crawls_completed
	)

	auto_throttle_level = (
		AUTO_THROTTLE_MIN_LEVEL
	)

	auto_throttle_enabled = false
	scheduled_crawls_completed = 0
	current_crawl_started_by_scheduler = false
	
	auto_throttle_cycles_used = 0

	cancel_auto_throttle_reaction()
	stop_auto_throttle_cooldown()

	if was_unlocked:
		auto_throttle_unlock_changed.emit(
			false
		)

	if (
		previous_level
		!= AUTO_THROTTLE_MIN_LEVEL
	):
		auto_throttle_level_changed.emit(
			AUTO_THROTTLE_MIN_LEVEL
		)

	if was_enabled:
		auto_throttle_enabled_changed.emit(
			false
		)

	if previous_completed_count != 0:
		scheduled_crawl_completed_count_changed.emit(
			0
		)
