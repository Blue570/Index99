extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal tutorial_started

signal tutorial_step_changed(
	step_id: StringName,
	title: String,
	message: String
)

signal tutorial_completed
signal tutorial_skipped


# -------------------------------------------------------------------
# Tutorial step identifiers
# -------------------------------------------------------------------

const STEP_WELCOME: StringName = &"welcome"
const STEP_RESOURCES: StringName = &"resources"
const STEP_CRAWLER: StringName = &"crawler"
const STEP_FIRST_CRAWL: StringName = &"first_crawl"
const STEP_SERVER_LOAD: StringName = &"server_load"
const STEP_OBJECTIVES: StringName = &"objectives"
const STEP_RESEARCH: StringName = &"research"
const STEP_SERVERS: StringName = &"servers"
const STEP_READY: StringName = &"ready"


# -------------------------------------------------------------------
# Tutorial sequence
# -------------------------------------------------------------------

const TUTORIAL_STEPS: Array[Dictionary] = [
	{
		"id": STEP_WELCOME,
		"title": "WELCOME TO INDEX 99",
		"message":
			"You are running a small search engine at the end "
			+ "of the 1990s. Your goal is to grow the index, "
			+ "attract users, earn revenue, and improve the system."
	},

	{
		"id": STEP_RESOURCES,
		"title": "RESOURCE BAR",
		"message":
			"The bar at the top tracks Revenue, Active Users, "
			+ "Indexed Pages, Reputation, and Server Load. "
			+ "These values update as your search engine grows."
	},

	{
		"id": STEP_CRAWLER,
		"title": "THE WEB CRAWLER",
		"message":
			"Open the Crawler tab now. This is where you "
			+ "manage crawl jobs and monitor indexing progress."
	},

	{
		"id": STEP_FIRST_CRAWL,
		"title": "START YOUR FIRST CRAWL",
		"message":
			"Start the Basic Crawl. The crawler will begin "
			+ "discovering pages, generating revenue, and "
			+ "attracting active users."
	},

	{
		"id": STEP_SERVER_LOAD,
		"title": "WATCH SERVER LOAD",
		"message":
			"Watch Server Load begin to increase while the crawler "
			+"runs. Heavy crawling consumes server capacity and "
			+"can eventually force an automatic pause."
	},

	{
		"id": STEP_OBJECTIVES,
		"title": "OBJECTIVES",
		"message":
			"The Dashboard shows your current objective. "
			+ "Completing objectives rewards Research Points "
			+ "and advances your progression."
	},

	{
		"id": STEP_RESEARCH,
		"title": "EXPLORE RESEARCH",
		"message":
			"Open the Research tab now. Research Points earned "
			+ "through progression can be spent on improvements "
			+ "to crawling, monetization, and audience growth."
	},

	{
		"id": STEP_SERVERS,
		"title": "EXPLORER SERVER UPGRADES",
		"message":
			"Open the Servers tab now. Revenue can be invested "
			+ "in Improved Colling, Efficient Crawling, and "
			+ "Load Buffering to support larger workloads."
	},

	{
		"id": STEP_READY,
		"title": "SYSTEM READY",
		"message":
			"You now know the core systems. Follow your objectives "
			+ "to grow the index and unlock additional technology."
	}
]


# -------------------------------------------------------------------
# Tutorial timing
# -------------------------------------------------------------------

const SERVER_LOAD_READ_DELAY_SECONDS: float = 10.0


# -------------------------------------------------------------------
# Runtime state
# -------------------------------------------------------------------

var current_step_index: int = 0

var tutorial_active: bool = false
var tutorial_has_been_completed: bool = false

var current_page_id: StringName = &""

var server_load_delay_started: bool = false


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_gameplay_signals()


func connect_gameplay_signals() -> void:
	if not CrawlerManager.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		CrawlerManager.crawler_state_changed.connect(
			_on_crawler_state_changed
		)

	if not GameState.server_load_changed.is_connected(
		_on_server_load_changed
	):
		GameState.server_load_changed.connect(
			_on_server_load_changed
		)


# -------------------------------------------------------------------
# Tutorial control
# -------------------------------------------------------------------

func start_tutorial(
	reset_progress: bool = false
) -> void:
	server_load_delay_started = false
	
	if (
		tutorial_has_been_completed
		and not reset_progress
	):
		return

	if reset_progress:
		current_step_index = 0
		tutorial_has_been_completed = false

	if (
		current_step_index < 0
		or current_step_index
		>= TUTORIAL_STEPS.size()
	):
		current_step_index = 0

	tutorial_active = true

	tutorial_started.emit()

	emit_current_step()
	
	call_deferred(
		"evaluate_crrent_step_state"
	)
	
func evaluate_current_step_state() -> void:
	if not tutorial_active:
		return

	var step_id: StringName = (
		get_current_step_id()
	)

	match step_id:
		STEP_FIRST_CRAWL:
			if GameState.crawler_running:
				advance_step(
					true
				)

		STEP_SERVER_LOAD:
			if (
				GameState.server_load > 0.0
				and not server_load_delay_started
			):
				server_load_delay_started = true

				begin_server_load_read_delay()


func advance_step(
	force_advance: bool = false
) -> void:
	if not tutorial_active:
		return

	if (
		current_step_requires_action()
		and not force_advance
	):
		return

	if is_last_step():
		complete_tutorial()
		return

	current_step_index += 1

	emit_current_step()


func complete_tutorial() -> void:
	if not tutorial_active:
		return

	tutorial_active = false
	tutorial_has_been_completed = true

	tutorial_completed.emit()


func skip_tutorial() -> void:
	if not tutorial_active:
		return

	tutorial_active = false
	tutorial_has_been_completed = true

	tutorial_skipped.emit()


func reset_tutorial() -> void:
	tutorial_active = false
	tutorial_has_been_completed = false
	current_step_index = 0

	server_load_delay_started = false


# -------------------------------------------------------------------
# Current step
# -------------------------------------------------------------------

func emit_current_step() -> void:
	var step_data: Dictionary = (
		get_current_step_data()
	)

	if step_data.is_empty():
		return

	tutorial_step_changed.emit(
		StringName(
			step_data.get(
				"id",
				STEP_WELCOME
			)
		),
		str(
			step_data.get(
				"title",
				"TUTORIAL"
			)
		),
		str(
			step_data.get(
				"message",
				""
			)
		)
	)


func get_current_step_data() -> Dictionary:
	if (
		current_step_index < 0
		or current_step_index
		>= TUTORIAL_STEPS.size()
	):
		return {}

	return TUTORIAL_STEPS[
		current_step_index
	]


func get_current_step_id() -> StringName:
	var step_data: Dictionary = (
		get_current_step_data()
	)

	return StringName(
		step_data.get(
			"id",
			STEP_WELCOME
		)
	)


func get_current_step_number() -> int:
	return current_step_index + 1


func get_total_step_count() -> int:
	return TUTORIAL_STEPS.size()
	
func current_step_requires_action() -> bool:
	var step_id: StringName = (
		get_current_step_id()
	)

	return (
		step_id == STEP_CRAWLER
		or step_id == STEP_FIRST_CRAWL
		or step_id == STEP_SERVER_LOAD
		or step_id == STEP_RESEARCH
		or step_id == STEP_SERVERS
	)


func is_last_step() -> bool:
	return (
		current_step_index
		>= TUTORIAL_STEPS.size() - 1
	)
	
# -------------------------------------------------------------------
# Page actions
# -------------------------------------------------------------------

func notify_page_opened(
	page_id: StringName
) -> void:
	current_page_id = page_id

	if not tutorial_active:
		return

	var step_id: StringName = (
		get_current_step_id()
	)

	match step_id:
		STEP_CRAWLER:
			if page_id == &"crawler":
				advance_step(
					true
				)

		STEP_RESEARCH:
			if page_id == &"research":
				advance_step(
					true
				)

		STEP_SERVERS:
			if page_id == &"servers":
				advance_step(
					true
				)
	
# -------------------------------------------------------------------
# Crawler actions
# -------------------------------------------------------------------

func _on_crawler_state_changed(
	is_running: bool
) -> void:
	if not tutorial_active:
		return

	if get_current_step_id() != STEP_FIRST_CRAWL:
		return

	if not is_running:
		return

	advance_step(
		true
	)
	
# -------------------------------------------------------------------
# Server-load actions
# -------------------------------------------------------------------

func _on_server_load_changed(
	new_load: float
) -> void:
	if not tutorial_active:
		return

	if get_current_step_id() != STEP_SERVER_LOAD:
		return

	if new_load <= 0.0:
		return

	if server_load_delay_started:
		return

	server_load_delay_started = true

	begin_server_load_read_delay()
	
func begin_server_load_read_delay() -> void:
	await get_tree().create_timer(
		SERVER_LOAD_READ_DELAY_SECONDS
	).timeout

	if not tutorial_active:
		return

	if get_current_step_id() != STEP_SERVER_LOAD:
		return

	advance_step(
		true
	)
	
# -------------------------------------------------------------------
# Save / load support
# -------------------------------------------------------------------

func restore_saved_state(
	saved_step_index: int,
	saved_completed: bool
) -> void:
	current_step_index = clampi(
		saved_step_index,
		0,
		TUTORIAL_STEPS.size() - 1
	)

	tutorial_has_been_completed = saved_completed
	tutorial_active = false

	server_load_delay_started = false
	
func should_start_tutorial() -> bool:
	return not tutorial_has_been_completed
