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

signal crawl_job_selection_changed(
	job_id: StringName,
	display_name: String,
	target_pages: int
)


# -------------------------------------------------------------------
# Temporary balance values
# -------------------------------------------------------------------

const TIMER_INTERVAL_SECONDS: float = 1.0
const DEFAULT_JOB_TARGET_PAGES: int = 100
const CRAWL_JOB_BASIC: StringName = &"basic"
const CRAWL_JOB_EXPANDED: StringName = &"expanded"
const CRAWL_JOB_DEEP: StringName = &"deep"

const CRAWL_JOBS: Dictionary = {
	CRAWL_JOB_BASIC: {
		"display_name": "Basic Crawl",
		"target_pages": 100,
		"required_tier": 1
	},

	CRAWL_JOB_EXPANDED: {
		"display_name": "Expanded Crawl",
		"target_pages": 250,
		"required_tier": 2
	},

	CRAWL_JOB_DEEP: {
		"display_name": "Deep Crawl",
		"target_pages": 500,
		"required_tier": 2
	}
}

const REVENUE_PER_PAGE: float = 1.0
const ACTIVE_USERS_PER_PAGE: float = 0.15

const BASE_CRAWLER_RATE: float = 1.0

# -------------------------------------------------------------------
# Manual Crawl Assist
# -------------------------------------------------------------------

const MANUAL_ASSIST_PROGRESS_PER_CLICK: float = 0.50
const MANUAL_ASSIST_SERVER_LOAD_PER_CLICK: float = 0.75

#---------------------------------------------------------------------
#Server Load
#---------------------------------------------------------------------


const SERVER_LOAD_INTERVAL_SECONDS: float = 1.0

const SERVER_LOAD_GAIN_PER_TICK: float = 1.5
const SERVER_LOAD_COOLING_PER_TICK: float = 6.0

const SERVER_LOAD_WARNING_THRESHOLD: float = 90.0
const SERVER_LOAD_RECOVERY_THRESHOLD: float = 50.0
const SERVER_LOAD_MAXIMUM: float = 100.0


# -------------------------------------------------------------------
# Runtime values
# -------------------------------------------------------------------

var crawler_timer: Timer
var server_load_timer: Timer


var current_job_pages: int = 0

var selected_job_id: StringName = (
	CRAWL_JOB_BASIC
)

var current_job_target_pages: int = (
	DEFAULT_JOB_TARGET_PAGES
)

var page_fraction_buffer: float = 0.0
var active_user_fraction_buffer: float = 0.0

var paused_for_overload: bool = false





# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_research_signals()

	apply_research_crawler_rate()

	create_crawler_timer()
	create_server_load_timer()
	
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
	)
	
	
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
	
func get_current_job_target_pages() -> int:
	return current_job_target_pages
	
func get_selected_job_id() -> StringName:
	return selected_job_id
	
func get_selected_job_display_name() -> String:
	if not CRAWL_JOBS.has(selected_job_id):
		return "Basic Crawl"

	var job_data: Dictionary = (
		CRAWL_JOBS[selected_job_id]
	)

	return str(
		job_data.get(
			"display_name",
			"Basic Crawl"
		)
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
	
func get_effective_recovery_threshold() -> float:
	var recovery_ratio: float = (
		SERVER_LOAD_RECOVERY_THRESHOLD
		/ SERVER_LOAD_MAXIMUM
	)

	return (
		get_effective_maximum_safe_load()
		* recovery_ratio
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

func can_use_manual_crawl_assist() -> bool:
	if not GameState.crawler_running:
		return false

	if paused_for_overload:
		return false

	if is_current_job_complete():
		return false

	return true
	
func use_manual_crawl_assist() -> bool:
	if not can_use_manual_crawl_assist():
		return false

	page_fraction_buffer += (
		MANUAL_ASSIST_PROGRESS_PER_CLICK
	)

	process_page_fraction_buffer()

	if is_current_job_complete():
		return true

	add_crawl_assist_server_load(
		MANUAL_ASSIST_SERVER_LOAD_PER_CLICK
	)

	return true
	
func apply_automated_crawl_assist(
	work_amount: float,
	server_load_amount: float
) -> bool:
	if not (
		ObjectiveManager
		.is_auto_crawl_assist_unlocked()
	):
		return false

	if not GameState.crawler_running:
		return false

	if paused_for_overload:
		return false

	if is_current_job_complete():
		return false

	if work_amount <= 0.0:
		return false

	page_fraction_buffer += (
		work_amount
	)

	process_page_fraction_buffer()

	if is_current_job_complete():
		return true

	add_crawl_assist_server_load(
		server_load_amount
	)

	return true

func start_crawler() -> void:
	if GameState.crawler_running:
		return
		
	if paused_for_overload:
		return

	# A finished 100-page batch becomes a new crawl
	# when the player presses Start Next Crawl.
	if is_current_job_complete():
		prepare_next_crawl_job()

	# Do not allow the crawler to start while the
	# server is still at or above its safe maximum.
	if (
		GameState.server_load
		>= get_effective_maximum_safe_load()
	):
		paused_for_overload = true

		GameState.set_crawler_running(
			false
		)

		crawler_state_changed.emit(
			false
		)

		emit_current_progress()

		return

	paused_for_overload = false

	GameState.set_crawler_running(
		true
	)

	crawler_timer.start()

	crawler_state_changed.emit(
		true
	)

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
	
func is_current_job_complete() -> bool:
	return (
		current_job_pages
		>= current_job_target_pages
	)


func prepare_next_crawl_job() -> void:
	current_job_pages = 0

	paused_for_overload = false

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

	process_page_fraction_buffer()
	
func process_page_fraction_buffer() -> void:
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
		current_job_target_pages - current_job_pages,
		0
	)

	var pages_added: int = mini(
		requested_pages,
		pages_remaining
	)

	if pages_added <= 0:
		complete_current_job()
		return

	process_indexed_pages(
		pages_added
	)
	
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

	if current_job_pages >= current_job_target_pages:
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
		
func add_crawl_assist_server_load(
	load_amount: float
) -> void:
	if load_amount <= 0.0:
		return

	var maximum_safe_load: float = (
		get_effective_maximum_safe_load()
	)

	var new_server_load: float = minf(
		GameState.server_load
		+ load_amount,
		maximum_safe_load
	)

	GameState.set_server_load(
		new_server_load
	)

	if new_server_load >= maximum_safe_load:
		pause_crawler_for_overload()
		
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
		< get_effective_recovery_threshold()
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
		current_job_target_pages,
		progress_percent
	)


func get_progress_percent() -> float:
	if current_job_target_pages <= 0:
		return 0.0

	return clampf(
		float(current_job_pages)
		/ float(current_job_target_pages)
		* 100.0,
		0.0,
		100.0
	)
	
func get_job_target_pages(
	job_id: StringName
) -> int:
	if not CRAWL_JOBS.has(job_id):
		return DEFAULT_JOB_TARGET_PAGES

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	return int(
		job_data.get(
			"target_pages",
			DEFAULT_JOB_TARGET_PAGES
		)
	)
	
func is_crawl_job_unlocked(
	job_id: StringName
) -> bool:
	if not CRAWL_JOBS.has(job_id):
		return false

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	var required_tier: int = int(
		job_data.get(
			"required_tier",
			ObjectiveManager.PROGRESSION_TIER_1
		)
	)

	return (
		ObjectiveManager.get_current_progression_tier()
		>= required_tier
	)
	
func select_crawl_job(
	job_id: StringName
) -> bool:
	if not CRAWL_JOBS.has(job_id):
		return false

	if not is_crawl_job_unlocked(job_id):
		return false

	if GameState.crawler_running:
		return false

	var previous_job_complete: bool = (
		is_current_job_complete()
	)

	if (
		current_job_pages > 0
		and not previous_job_complete
	):
		return false

	# Selecting the already-selected job does not
	# need to change anything.
	if job_id == selected_job_id:
		return true

	selected_job_id = job_id

	current_job_target_pages = (
		get_job_target_pages(job_id)
	)

	# If the previous crawl was already complete,
	# switching job types prepares a fresh job.
	if previous_job_complete:
		current_job_pages = 0
		paused_for_overload = false

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	crawl_job_selection_changed.emit(
		selected_job_id,
		str(
			job_data.get(
				"display_name",
				"Crawl"
			)
		),
		current_job_target_pages
	)

	emit_current_progress()

	return true
	
# -------------------------------------------------------------------
# Completion
# -------------------------------------------------------------------

func complete_current_job() -> void:
	current_job_pages = (
		current_job_target_pages
	)

	crawler_timer.stop()

	GameState.set_crawler_running(
		false
	)

	crawler_state_changed.emit(
		false
	)

	emit_current_progress()

	crawl_job_completed.emit()
	
# -------------------------------------------------------------------
# Save / load support
# -------------------------------------------------------------------

func restore_saved_state(
	
	saved_job_pages: int,
	saved_page_fraction: float,
	saved_active_user_fraction: float,
	saved_running: bool,
	saved_paused_for_overload: bool,
	saved_job_id: StringName
) -> void:
	if CRAWL_JOBS.has(saved_job_id):
		selected_job_id = saved_job_id
	else:
		selected_job_id = CRAWL_JOB_BASIC
		
	current_job_target_pages = (
		get_job_target_pages(
			selected_job_id
		)
	)
	
	current_job_pages = clampi(
		saved_job_pages,
		0,
		current_job_target_pages
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
		paused_for_overload
		and GameState.server_load
		< get_effective_recovery_threshold()
	):
		paused_for_overload = false

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
		< current_job_target_pages
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
	
# -------------------------------------------------------------------
# New-game reset
# -------------------------------------------------------------------

func reset_crawler_state() -> void:
	crawler_timer.stop()

	current_job_pages = 0
	page_fraction_buffer = 0.0
	active_user_fraction_buffer = 0.0

	paused_for_overload = false
	
	selected_job_id = CRAWL_JOB_BASIC

	current_job_target_pages = (
		DEFAULT_JOB_TARGET_PAGES
	)

	GameState.set_crawler_running(
		false
	)

	crawler_state_changed.emit(
		false
	)

	emit_current_progress()
	
func get_job_display_name(
	job_id: StringName
) -> String:
	if not CRAWL_JOBS.has(job_id):
		return "Unknown Crawl"

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	return str(
		job_data.get(
			"display_name",
			"Unknown Crawl"
		)
	)
	
#----------------------------------------------------------------------------------------TEST
func _on_progression_tier_changed(
	new_tier: int
) -> void:
	print(
		"CrawlerManager received progression tier: ",
		new_tier
	)

	print(
		"Current Progression Tier: ",
		ObjectiveManager.get_current_progression_tier()
	)

	print(
		"Basic unlocked: ",
		is_crawl_job_unlocked(
			CRAWL_JOB_BASIC
		)
	)

	print(
		"Expanded unlocked: ",
		is_crawl_job_unlocked(
			CRAWL_JOB_EXPANDED
		)
	)

	print(
		"Deep unlocked: ",
		is_crawl_job_unlocked(
			CRAWL_JOB_DEEP
		)
	)
	
