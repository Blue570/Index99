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
# Runtime
# -------------------------------------------------------------------

var auto_assist_timer: Timer

var auto_crawl_assist_level: int = (
	AUTO_ASSIST_MIN_LEVEL
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_auto_assist_timer()

	connect_progression_signals()

	call_deferred(
		"synchronize_auto_assist_with_progression"
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


func connect_progression_signals() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)


func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	synchronize_auto_assist_with_progression()


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
	return (
		get_auto_assist_work_per_second_for_level(
			auto_crawl_assist_level
		)
	)


func get_auto_assist_load_per_second() -> float:
	return (
		get_auto_assist_load_per_second_for_level(
			auto_crawl_assist_level
		)
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
		GameState.crawler_rate
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
