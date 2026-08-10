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

const BASE_CRAWLER_RATE: float = 1.0


# -------------------------------------------------------------------
# Runtime values
# -------------------------------------------------------------------

var crawler_timer: Timer
var server_load_timer: Timer


var current_job_pages: int = 0

var page_fraction_buffer: float = 0.0
var active_user_fraction_buffer: float = 0.0

var paused_for_overload: bool = false


#---------------------------------------------------------------------
#Server Load
#---------------------------------------------------------------------


const SERVER_LOAD_INTERVAL_SECONDS: float = 1.0

const SERVER_LOAD_GAIN_PER_TICK: float = 2.0
const SERVER_LOAD_COOLING_PER_TICK: float = 5.0

const SERVER_LOAD_WARNING_THRESHOLD: float = 90.0
const SERVER_LOAD_MAXIMUM: float = 100.0


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_research_signals()

	apply_research_crawler_rate()

	create_crawler_timer()
	create_server_load_timer()
	
func connect_research_signals() -> void:
	if not ResearchManager.research_upgrade_level_changed.is_connected(
		_on_research_upgrade_level_changed
	):
		ResearchManager.research_upgrade_level_changed.connect(
			_on_research_upgrade_level_changed
		)
		
func _on_research_upgrade_level_changed(
	_upgrade_id: StringName,
	_new_level: int
) -> void:
	apply_research_crawler_rate()
	
func apply_research_crawler_rate() -> void:
	var research_bonus: float = (
		ResearchManager.get_crawler_optimization_bonus()
	)

	var effective_crawler_rate: float = (
		BASE_CRAWLER_RATE
		+ research_bonus
	)

	GameState.set_crawler_rate(
		effective_crawler_rate
	)
	
func get_effective_revenue_per_page() -> float:
	var bonus_percent: float = (
		ResearchManager
		.get_search_monetization_bonus_percent()
	)

	var multiplier: float = (
		1.0
		+ bonus_percent / 100.0
	)

	return (
		REVENUE_PER_PAGE
		* multiplier
	)


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
	
func create_server_load_timer() -> void:
	server_load_timer = Timer.new()
	server_load_timer.name = "ServerLoadTimer"

	server_load_timer.wait_time = (
		SERVER_LOAD_INTERVAL_SECONDS
	)

	server_load_timer.one_shot = false
	server_load_timer.autostart = false

	add_child(server_load_timer)

	server_load_timer.timeout.connect(
		_on_server_load_timer_timeout
	)

	server_load_timer.start()
	
func get_effective_active_users_per_page() -> float:
	var bonus_percent: float = (
		ResearchManager
		.get_audience_discovery_bonus_percent()
	)

	var multiplier: float = (
		1.0
		+ bonus_percent / 100.0
	)

	return (
		ACTIVE_USERS_PER_PAGE
		* multiplier
	)
	
# -------------------------------------------------------------------
# Effective server values
# -------------------------------------------------------------------

func get_effective_cooling_rate() -> float:
	return (
		SERVER_LOAD_COOLING_PER_TICK
		+ ServerManager.get_cooling_speed_bonus()
	)


func get_effective_server_load_generation() -> float:
	var reduced_load: float = (
		SERVER_LOAD_GAIN_PER_TICK
		- ServerManager.get_crawler_efficiency_reduction()
	)

	return maxf(
		reduced_load,
		0.1
	)


func get_effective_maximum_safe_load() -> float:
	return (
		SERVER_LOAD_MAXIMUM
		+ ServerManager.get_maximum_safe_load_bonus()
	)


func get_effective_warning_threshold() -> float:
	var warning_ratio: float = (
		SERVER_LOAD_WARNING_THRESHOLD
		/ SERVER_LOAD_MAXIMUM
	)

	return (
		get_effective_maximum_safe_load()
		* warning_ratio
	)


func get_server_load_usage_percent(
	load_value: float
) -> float:
	var maximum_safe_load: float = (
		get_effective_maximum_safe_load()
	)

	if maximum_safe_load <= 0.0:
		return 0.0

	return clampf(
		load_value
		/ maximum_safe_load
		* 100.0,
		0.0,
		100.0
	)
	
# -------------------------------------------------------------------
# Crawler controls
# -------------------------------------------------------------------

func start_crawler() -> void:
	if paused_for_overload:
		return

	if (
		GameState.server_load
		>= get_effective_maximum_safe_load()
	):
		return

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
	
func pause_crawler_for_overload() -> void:
	paused_for_overload = true

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
	* get_effective_revenue_per_page()
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
	* get_effective_active_users_per_page()
	)

	var users_added: int = floori(
		active_user_fraction_buffer
	)

	if users_added > 0:
		active_user_fraction_buffer -= float(
			users_added
		)

	return users_added
	
func _on_server_load_timer_timeout() -> void:
	if GameState.crawler_running:
		increase_server_load()
	else:
		decrease_server_load()
		
func increase_server_load() -> void:
	var maximum_safe_load: float = (
		get_effective_maximum_safe_load()
	)

	var generated_load: float = (
		get_effective_server_load_generation()
	)

	var new_server_load: float = minf(
		GameState.server_load + generated_load,
		maximum_safe_load
	)

	GameState.set_server_load(
		new_server_load
	)

	if new_server_load >= maximum_safe_load:
		pause_crawler_for_overload()
		
func decrease_server_load() -> void:
	if GameState.server_load <= 0.0:
		if paused_for_overload:
			paused_for_overload = false

		return

	var cooled_server_load: float = maxf(
		GameState.server_load
		- get_effective_cooling_rate(),
		0.0
	)

	var recovered_from_overload: bool = (
		paused_for_overload
		and cooled_server_load
		< get_effective_warning_threshold()
	)

	if recovered_from_overload:
		paused_for_overload = false

	GameState.set_server_load(
		cooled_server_load
	)

	if recovered_from_overload:
		crawler_state_changed.emit(false)
	
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
	
# -------------------------------------------------------------------
# Save / load support
# -------------------------------------------------------------------

func restore_saved_state(
	saved_job_pages: int,
	saved_page_fraction: float,
	saved_active_user_fraction: float,
	saved_running: bool,
	saved_paused_for_overload: bool
) -> void:
	current_job_pages = clampi(
		saved_job_pages,
		0,
		CURRENT_JOB_TARGET_PAGES
	)

	page_fraction_buffer = clampf(
		saved_page_fraction,
		0.0,
		0.999999
	)

	active_user_fraction_buffer = clampf(
		saved_active_user_fraction,
		0.0,
		0.999999
	)

	paused_for_overload = (
		saved_paused_for_overload
	)

	crawler_timer.stop()

	if (
		saved_running
		and GameState.server_load
		>= get_effective_maximum_safe_load()
	):
		paused_for_overload = true

	var should_run: bool = (
		saved_running
		and not paused_for_overload
		and current_job_pages
		< CURRENT_JOB_TARGET_PAGES
	)

	GameState.set_crawler_running(
		should_run
	)

	if should_run:
		crawler_timer.start()

	crawler_state_changed.emit(
		should_run
	)

	emit_current_progress()
	
