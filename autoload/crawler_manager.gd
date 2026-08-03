extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal crawler_state_changed(is_running: bool)

signal crawler_progress_changed(
	pages_processed: int,
	target_pages: int,
	progress_percent: float
)

signal crawler_tick_completed(
	pages_added: int,
	revenue_added: float,
	active_users_added: int
)

signal crawl_job_completed


# -------------------------------------------------------------------
# Temporary balance values
# -------------------------------------------------------------------

const TIMER_INTERVAL_SECONDS: float = 1.0
const CURRENT_JOB_TARGET_PAGES: int = 100

const REVENUE_PER_PAGE: float = 0.10
const ACTIVE_USERS_PER_PAGE: float = 0.20


# -------------------------------------------------------------------
# Runtime values
# -------------------------------------------------------------------

var crawler_timer: Timer

var current_job_pages: int = 0

var page_fraction_buffer: float = 0.0
var active_user_fraction_buffer: float = 0.0


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_crawler_timer()


func create_crawler_timer() -> void:
	crawler_timer = Timer.new()
	crawler_timer.name = "CrawlerTimer"

	crawler_timer.wait_time = TIMER_INTERVAL_SECONDS
	crawler_timer.one_shot = false
	crawler_timer.autostart = false

	add_child(crawler_timer)

	crawler_timer.timeout.connect(
		_on_crawler_timer_timeout
	)
	
# -------------------------------------------------------------------
# Crawler controls
# -------------------------------------------------------------------

func start_crawler() -> void:
	if current_job_pages >= CURRENT_JOB_TARGET_PAGES:
		emit_current_progress()
		return

	if GameState.crawler_running:
		return

	GameState.set_crawler_running(true)

	crawler_timer.start()

	crawler_state_changed.emit(true)

	emit_current_progress()
	
func pause_crawler() -> void:
	if (
		not GameState.crawler_running
		and crawler_timer.is_stopped()
	):
		return

	crawler_timer.stop()

	GameState.set_crawler_running(false)

	crawler_state_changed.emit(false)

	emit_current_progress()
	
# -------------------------------------------------------------------
# Timer processing
# -------------------------------------------------------------------

func _on_crawler_timer_timeout() -> void:
	if not GameState.crawler_running:
		return

	page_fraction_buffer += (
		GameState.crawler_rate
		* TIMER_INTERVAL_SECONDS
	)

	var requested_pages: int = floori(
		page_fraction_buffer
	)

	if requested_pages <= 0:
		emit_current_progress()
		return

	page_fraction_buffer -= float(
		requested_pages
	)

	var pages_remaining: int = maxi(
		CURRENT_JOB_TARGET_PAGES - current_job_pages,
		0
	)

	var pages_added: int = mini(
		requested_pages,
		pages_remaining
	)

	if pages_added <= 0:
		complete_current_job()
		return

	process_indexed_pages(pages_added)
	
func process_indexed_pages(pages_added: int) -> void:
	current_job_pages += pages_added

	GameState.set_indexed_pages(
		GameState.indexed_pages + pages_added
	)

	var revenue_added: float = (
		float(pages_added)
		* REVENUE_PER_PAGE
	)

	GameState.set_revenue(
		GameState.revenue + revenue_added
	)

	var active_users_added: int = calculate_active_user_growth(
		pages_added
	)

	if active_users_added > 0:
		GameState.set_active_users(
			GameState.active_users
			+ active_users_added
		)

	crawler_tick_completed.emit(
		pages_added,
		revenue_added,
		active_users_added
	)

	emit_current_progress()

	if current_job_pages >= CURRENT_JOB_TARGET_PAGES:
		complete_current_job()
		
func calculate_active_user_growth(
	pages_added: int
) -> int:
	active_user_fraction_buffer += (
		float(pages_added)
		* ACTIVE_USERS_PER_PAGE
	)

	var users_added: int = floori(
		active_user_fraction_buffer
	)

	if users_added > 0:
		active_user_fraction_buffer -= float(
			users_added
		)

	return users_added
	
# -------------------------------------------------------------------
# Progress
# -------------------------------------------------------------------

func emit_current_progress() -> void:
	var progress_percent: float = get_progress_percent()

	crawler_progress_changed.emit(
		current_job_pages,
		CURRENT_JOB_TARGET_PAGES,
		progress_percent
	)


func get_progress_percent() -> float:
	if CURRENT_JOB_TARGET_PAGES <= 0:
		return 100.0

	var progress_percent: float = (
		float(current_job_pages)
		/ float(CURRENT_JOB_TARGET_PAGES)
		* 100.0
	)

	return clampf(
		progress_percent,
		0.0,
		100.0
	)
	
# -------------------------------------------------------------------
# Completion
# -------------------------------------------------------------------

func complete_current_job() -> void:
	crawler_timer.stop()

	GameState.set_crawler_running(false)

	crawler_state_changed.emit(false)

	crawl_job_completed.emit()
	
