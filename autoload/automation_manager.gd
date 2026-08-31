extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal auto_crawl_assist_tick(
	work_added: float,
	server_load_added: float
)


# -------------------------------------------------------------------
# Auto Crawl Assist balance
# -------------------------------------------------------------------

const AUTO_ASSIST_INTERVAL_SECONDS: float = 0.50

const AUTO_ASSIST_WORK_PER_TICK: float = 0.50

const AUTO_ASSIST_SERVER_LOAD_PER_TICK: float = 0.40


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var auto_assist_timer: Timer


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_auto_assist_timer()


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


# -------------------------------------------------------------------
# Unlock / state
# -------------------------------------------------------------------

func is_auto_assist_unlocked() -> bool:
	return (
		ObjectiveManager
		.is_auto_crawl_assist_unlocked()
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
# Information
# -------------------------------------------------------------------

func get_auto_assist_work_per_second() -> float:
	return (
		AUTO_ASSIST_WORK_PER_TICK
		/ AUTO_ASSIST_INTERVAL_SECONDS
	)


func get_auto_assist_load_per_second() -> float:
	return (
		AUTO_ASSIST_SERVER_LOAD_PER_TICK
		/ AUTO_ASSIST_INTERVAL_SECONDS
	)
	
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

	var assist_applied: bool = (
		CrawlerManager.apply_automated_crawl_assist(
			AUTO_ASSIST_WORK_PER_TICK,
			AUTO_ASSIST_SERVER_LOAD_PER_TICK
		)
	)

	if not assist_applied:
		return

	auto_crawl_assist_tick.emit(
		AUTO_ASSIST_WORK_PER_TICK,
		AUTO_ASSIST_SERVER_LOAD_PER_TICK
	)
