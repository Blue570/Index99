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

signal crawler_priority_changed(
	priority_id: StringName
)

signal crawler_recovered_from_overload

signal quick_crawl_jobs_changed
signal crawl_job_queue_changed


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
		"description":
			"A small general-purpose crawl with a short "
			+ "completion time.",
		"target_pages": 100,
		"required_tier": 1
	},

	CRAWL_JOB_EXPANDED: {
		"display_name": "Expanded Crawl",
		"description":
			"A broader crawl that searches more linked "
			+ "domains and takes longer to finish.",
		"target_pages": 250,
		"required_tier": 2
	},

	CRAWL_JOB_DEEP: {
		"display_name": "Deep Crawl",
		"description":
			"A long crawl that follows deeper link paths "
			+ "for sustained indexing.",
		"target_pages": 500,
		"required_tier": 2
	}
}

const CRAWL_JOB_ORDER: Array[StringName] = [
	CRAWL_JOB_BASIC,
	CRAWL_JOB_EXPANDED,
	CRAWL_JOB_DEEP
]

const QUICK_CRAWL_SLOT_COUNT: int = 3

const MAX_CRAWL_JOB_QUEUE_SIZE: int = 10

const REVENUE_PER_PAGE: float = 1.0
const ACTIVE_USERS_PER_PAGE: float = 0.15

const BASE_CRAWLER_RATE: float = 1.0


# -------------------------------------------------------------------
# Crawler Priorities
# -------------------------------------------------------------------

const PRIORITY_SPEED: StringName = &"speed"
const PRIORITY_BALANCED: StringName = &"balanced"
const PRIORITY_EFFICIENCY: StringName = &"efficiency"

const CRAWLER_PRIORITIES: Dictionary = {
	PRIORITY_SPEED: {
		"display_name": "Speed",
		"crawl_multiplier": 1.25,
		"load_multiplier": 1.30
	},

	PRIORITY_BALANCED: {
		"display_name": "Balanced",
		"crawl_multiplier": 1.00,
		"load_multiplier": 1.00
	},

	PRIORITY_EFFICIENCY: {
		"display_name": "Efficiency",
		"crawl_multiplier": 0.85,
		"load_multiplier": 0.70
	}
}

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

var quick_crawl_job_ids: Array[StringName] = [
	CRAWL_JOB_BASIC,
	CRAWL_JOB_EXPANDED,
	CRAWL_JOB_DEEP
]

var crawl_job_queue: Array[StringName] = []

var page_fraction_buffer: float = 0.0
var active_user_fraction_buffer: float = 0.0

var paused_for_overload: bool = false
var paused_for_auto_throttle: bool = false

var current_crawler_priority: StringName = (
	PRIORITY_BALANCED
)



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
# Crawl Job Catalog
# -------------------------------------------------------------------

func get_all_crawl_job_ids() -> Array[StringName]:
	var job_ids: Array[StringName] = []

	for job_id: StringName in CRAWL_JOB_ORDER:
		job_ids.append(
			job_id
		)

	return job_ids


func get_crawl_job_description(
	job_id: StringName
) -> String:
	if not CRAWL_JOBS.has(
		job_id
	):
		return ""

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	return str(
		job_data.get(
			"description",
			""
		)
	)


func get_crawl_job_required_tier(
	job_id: StringName
) -> int:
	if not CRAWL_JOBS.has(
		job_id
	):
		return 999

	var job_data: Dictionary = (
		CRAWL_JOBS[job_id]
	)

	return int(
		job_data.get(
			"required_tier",
			1
		)
	)
	
# -------------------------------------------------------------------
# Quick Crawl Slots
# -------------------------------------------------------------------

func get_quick_crawl_job_ids() -> Array[StringName]:
	var job_ids: Array[StringName] = []

	for job_id: StringName in quick_crawl_job_ids:
		job_ids.append(
			job_id
		)

	return job_ids


func get_quick_crawl_job_id(
	slot_index: int
) -> StringName:
	if (
		slot_index < 0
		or slot_index
		>= quick_crawl_job_ids.size()
	):
		return &""

	return quick_crawl_job_ids[
		slot_index
	]


func is_crawl_job_quick_selected(
	job_id: StringName
) -> bool:
	return quick_crawl_job_ids.has(
		job_id
	)


func get_crawl_job_quick_slot(
	job_id: StringName
) -> int:
	return quick_crawl_job_ids.find(
		job_id
	)


func set_quick_crawl_job(
	slot_index: int,
	job_id: StringName
) -> bool:
	if (
		slot_index < 0
		or slot_index >= QUICK_CRAWL_SLOT_COUNT
	):
		return false

	if not CRAWL_JOBS.has(
		job_id
	):
		return false

	if (
		quick_crawl_job_ids[
			slot_index
		]
		== job_id
	):
		return true

	var existing_slot_index: int = (
		quick_crawl_job_ids.find(
			job_id
		)
	)

	if existing_slot_index >= 0:
		var replaced_job_id: StringName = (
			quick_crawl_job_ids[
				slot_index
			]
		)

		quick_crawl_job_ids[
			slot_index
		] = job_id

		quick_crawl_job_ids[
			existing_slot_index
		] = replaced_job_id

	else:
		quick_crawl_job_ids[
			slot_index
		] = job_id

	quick_crawl_jobs_changed.emit()

	return true
	
# -------------------------------------------------------------------
# Crawl Job Queue
# -------------------------------------------------------------------

func get_crawl_job_queue() -> Array[StringName]:
	var queued_jobs: Array[StringName] = []

	for job_id: StringName in crawl_job_queue:
		queued_jobs.append(
			job_id
		)

	return queued_jobs


func get_crawl_job_queue_size() -> int:
	return crawl_job_queue.size()


func is_crawl_job_queue_full() -> bool:
	return (
		crawl_job_queue.size()
		>= MAX_CRAWL_JOB_QUEUE_SIZE
	)


func can_add_crawl_job_to_queue(
	job_id: StringName
) -> bool:
	if not CRAWL_JOBS.has(
		job_id
	):
		return false

	if not is_crawl_job_unlocked(
		job_id
	):
		return false

	if is_crawl_job_queue_full():
		return false

	return true


func add_crawl_job_to_queue(
	job_id: StringName
) -> bool:
	if not can_add_crawl_job_to_queue(
		job_id
	):
		return false

	crawl_job_queue.append(
		job_id
	)

	crawl_job_queue_changed.emit()

	return true


func remove_crawl_job_from_queue(
	queue_index: int
) -> bool:
	if (
		queue_index < 0
		or queue_index
		>= crawl_job_queue.size()
	):
		return false

	crawl_job_queue.remove_at(
		queue_index
	)

	crawl_job_queue_changed.emit()

	return true


func move_crawl_job_in_queue(
	from_index: int,
	to_index: int
) -> bool:
	if (
		from_index < 0
		or from_index
		>= crawl_job_queue.size()
	):
		return false

	if (
		to_index < 0
		or to_index
		>= crawl_job_queue.size()
	):
		return false

	if from_index == to_index:
		return true

	var job_id: StringName = (
		crawl_job_queue[
			from_index
		]
	)

	crawl_job_queue.remove_at(
		from_index
	)

	crawl_job_queue.insert(
		to_index,
		job_id
	)

	crawl_job_queue_changed.emit()

	return true


func clear_crawl_job_queue() -> void:
	if crawl_job_queue.is_empty():
		return

	crawl_job_queue.clear()

	crawl_job_queue_changed.emit()


func peek_next_queued_crawl_job() -> StringName:
	if crawl_job_queue.is_empty():
		return &""

	return crawl_job_queue[0]


func take_next_queued_crawl_job() -> StringName:
	if crawl_job_queue.is_empty():
		return &""

	var job_id: StringName = (
		crawl_job_queue.pop_front()
	)

	crawl_job_queue_changed.emit()

	return job_id
	
func reset_crawl_job_configuration() -> void:
	quick_crawl_job_ids = [
		CRAWL_JOB_BASIC,
		CRAWL_JOB_EXPANDED,
		CRAWL_JOB_DEEP
	]

	crawl_job_queue.clear()

	quick_crawl_jobs_changed.emit()
	crawl_job_queue_changed.emit()
	
func restore_crawl_job_configuration(
	saved_quick_job_ids: Array[StringName],
	saved_queue: Array[StringName]
) -> void:
	var default_quick_job_ids: Array[StringName] = [
		CRAWL_JOB_BASIC,
		CRAWL_JOB_EXPANDED,
		CRAWL_JOB_DEEP
	]

	var restored_quick_job_ids: Array[StringName] = []

	for job_id: StringName in saved_quick_job_ids:
		if (
			restored_quick_job_ids.size()
			>= QUICK_CRAWL_SLOT_COUNT
		):
			break

		if not CRAWL_JOBS.has(
			job_id
		):
			continue

		if restored_quick_job_ids.has(
			job_id
		):
			continue

		restored_quick_job_ids.append(
			job_id
		)

	for default_job_id: StringName in default_quick_job_ids:
		if (
			restored_quick_job_ids.size()
			>= QUICK_CRAWL_SLOT_COUNT
		):
			break

		if restored_quick_job_ids.has(
			default_job_id
		):
			continue

		restored_quick_job_ids.append(
			default_job_id
		)

	quick_crawl_job_ids = restored_quick_job_ids

	crawl_job_queue.clear()

	for job_id: StringName in saved_queue:
		if (
			crawl_job_queue.size()
			>= MAX_CRAWL_JOB_QUEUE_SIZE
		):
			break

		if not CRAWL_JOBS.has(
			job_id
		):
			continue

		if not is_crawl_job_unlocked(
			job_id
		):
			continue

		crawl_job_queue.append(
			job_id
		)

	quick_crawl_jobs_changed.emit()
	crawl_job_queue_changed.emit()
	
# -------------------------------------------------------------------
# Crawler Priorities
# -------------------------------------------------------------------

func get_current_crawler_priority() -> StringName:
	return current_crawler_priority


func is_crawler_priority_unlocked() -> bool:
	return (
		ObjectiveManager.get_current_progression_tier()
		>= ObjectiveManager.PROGRESSION_TIER_2
	)


func is_crawler_priority_valid(
	priority_id: StringName
) -> bool:
	return CRAWLER_PRIORITIES.has(
		priority_id
	)


func set_crawler_priority(
	priority_id: StringName
) -> bool:
	if not is_crawler_priority_valid(
		priority_id
	):
		return false

	# Balanced is always allowed internally so the
	# crawler has a safe default before Tier 2.
	if (
		priority_id != PRIORITY_BALANCED
		and not is_crawler_priority_unlocked()
	):
		return false

	if priority_id == current_crawler_priority:
		return false

	current_crawler_priority = priority_id

	crawler_priority_changed.emit(
		current_crawler_priority
	)

	return true


func get_crawler_priority_display_name(
	priority_id: StringName
) -> String:
	if not CRAWLER_PRIORITIES.has(
		priority_id
	):
		return "Balanced"

	var priority_data: Dictionary = (
		CRAWLER_PRIORITIES[priority_id]
	)

	return str(
		priority_data.get(
			"display_name",
			"Balanced"
		)
	)


func get_current_crawler_priority_display_name() -> String:
	return get_crawler_priority_display_name(
		current_crawler_priority
	)


func get_priority_crawl_multiplier() -> float:
	if not CRAWLER_PRIORITIES.has(
		current_crawler_priority
	):
		return 1.0

	var priority_data: Dictionary = (
		CRAWLER_PRIORITIES[
			current_crawler_priority
		]
	)

	return float(
		priority_data.get(
			"crawl_multiplier",
			1.0
		)
	)


func get_priority_load_multiplier() -> float:
	if not CRAWLER_PRIORITIES.has(
		current_crawler_priority
	):
		return 1.0

	var priority_data: Dictionary = (
		CRAWLER_PRIORITIES[
			current_crawler_priority
		]
	)

	return float(
		priority_data.get(
			"load_multiplier",
			1.0
		)
	)


func get_effective_automatic_crawl_rate() -> float:
	return (
		GameState.crawler_rate
		* get_priority_crawl_multiplier()
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

	var priority_adjusted_load: float = (
		reduced_load
		* get_priority_load_multiplier()
	)

	return maxf(
		priority_adjusted_load,
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
	

# -------------------------------------------------------------------
# Crawler Event Effects
# -------------------------------------------------------------------

func apply_crawler_event_work(
	work_amount: float
) -> int:
	if not GameState.crawler_running:
		return 0

	if paused_for_overload:
		return 0

	if is_current_job_complete():
		return 0

	if work_amount <= 0.0:
		return 0

	var pages_before: int = (
		current_job_pages
	)

	page_fraction_buffer += (
		work_amount
	)

	process_page_fraction_buffer()

	var pages_added: int = maxi(
		current_job_pages - pages_before,
		0
	)

	return pages_added


func apply_crawler_event_server_load(
	load_amount: float
) -> float:
	if load_amount <= 0.0:
		return 0.0

	var previous_load: float = (
		GameState.server_load
	)

	var maximum_safe_load: float = (
		get_effective_maximum_safe_load()
	)

	var new_server_load: float = minf(
		previous_load + load_amount,
		maximum_safe_load
	)

	GameState.set_server_load(
		new_server_load
	)

	var actual_load_added: float = maxf(
		new_server_load - previous_load,
		0.0
	)

	if (
		GameState.crawler_running
		and not is_current_job_complete()
		and new_server_load >= maximum_safe_load
	):
		pause_crawler_for_overload()

	return actual_load_added

func start_crawler() -> void:
	if GameState.crawler_running:
		return
		
	if paused_for_overload:
		return

	if paused_for_auto_throttle:
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
	
func pause_crawler_for_auto_throttle() -> bool:
	if not GameState.crawler_running:
		return false

	if paused_for_overload:
		return false

	if paused_for_auto_throttle:
		return false

	if is_current_job_complete():
		return false

	paused_for_auto_throttle = true

	crawler_timer.stop()

	GameState.set_crawler_running(
		false
	)

	crawler_state_changed.emit(
		false
	)

	emit_current_progress()

	return true
	
func resume_crawler_from_auto_throttle() -> bool:
	if not paused_for_auto_throttle:
		return false

	if paused_for_overload:
		return false

	if is_current_job_complete():
		paused_for_auto_throttle = false
		return false

	paused_for_auto_throttle = false

	start_crawler()

	return GameState.crawler_running
	
func is_current_job_complete() -> bool:
	return (
		current_job_pages
		>= current_job_target_pages
	)


func prepare_next_crawl_job() -> void:
	current_job_pages = 0

	paused_for_overload = false
	paused_for_auto_throttle = false

	emit_current_progress()
	
# -------------------------------------------------------------------
# Timer processing
# -------------------------------------------------------------------

func _on_crawler_timer_timeout() -> void:
	if not GameState.crawler_running:
		return

	page_fraction_buffer += (
		get_effective_automatic_crawl_rate()
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

			crawler_state_changed.emit(
				false
			)

			crawler_recovered_from_overload.emit()

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
		crawler_state_changed.emit(
			false
		)

		crawler_recovered_from_overload.emit()
	
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
		paused_for_auto_throttle = false

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
	
	paused_for_auto_throttle = false

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
	
	paused_for_auto_throttle = false

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
	paused_for_auto_throttle = false
	
	current_crawler_priority = (
		PRIORITY_BALANCED
	)
	
	crawler_priority_changed.emit(
		current_crawler_priority
	)
	
	selected_job_id = CRAWL_JOB_BASIC

	current_job_target_pages = (
		DEFAULT_JOB_TARGET_PAGES
	)
	
	reset_crawl_job_configuration()

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
	
