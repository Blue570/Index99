extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal event_added(
	message: String,
	category: StringName
)

signal history_changed


# -------------------------------------------------------------------
# Event history
# -------------------------------------------------------------------

const MAX_STORED_EVENTS: int = 30

var events: Array[Dictionary] = []


# -------------------------------------------------------------------
# State tracking
# -------------------------------------------------------------------

var known_progression_tier: int = 1


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	known_progression_tier = (
		ObjectiveManager.get_current_progression_tier()
	)

	call_deferred(
		"connect_event_signals"
	)

	print(
		"EventLogManager loaded successfully."
	)


# -------------------------------------------------------------------
# Signal connections
# -------------------------------------------------------------------

func connect_event_signals() -> void:
	if not CrawlerManager.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		CrawlerManager.crawler_state_changed.connect(
			_on_crawler_state_changed
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed
		)

	if not ServerManager.server_upgrade_purchased.is_connected(
		_on_server_upgrade_purchased
	):
		ServerManager.server_upgrade_purchased.connect(
			_on_server_upgrade_purchased
		)

	if not ResearchManager.research_upgrade_purchased.is_connected(
		_on_research_upgrade_purchased
	):
		ResearchManager.research_upgrade_purchased.connect(
			_on_research_upgrade_purchased
		)

	if not ObjectiveManager.objective_completed.is_connected(
		_on_objective_completed
	):
		ObjectiveManager.objective_completed.connect(
			_on_objective_completed
		)

	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)


# -------------------------------------------------------------------
# Event history
# -------------------------------------------------------------------

func add_event(
	message: String,
	category: StringName = &"information"
) -> void:
	var clean_message: String = (
		message.strip_edges()
	)

	if clean_message.is_empty():
		return

	var current_time: String = (
		Time.get_time_string_from_system(false)
	)

	var display_time: String = (
		current_time.substr(0, 5)
	)

	var event_data: Dictionary = {
		"time": display_time,
		"message": clean_message,
		"category": category
	}

	events.push_front(
		event_data
	)

	while events.size() > MAX_STORED_EVENTS:
		events.pop_back()

	event_added.emit(
		clean_message,
		category
	)

	history_changed.emit()
	
	print(
		"EVENT LOG: ",
		clean_message
	)


func get_recent_events(
	maximum_count: int = 3
) -> Array[Dictionary]:
	var recent_events: Array[Dictionary] = []

	var safe_count: int = mini(
		maxi(maximum_count, 0),
		events.size()
	)

	for event_index: int in range(
		safe_count
	):
		recent_events.append(
			events[event_index]
		)

	return recent_events


func clear_events() -> void:
	if events.is_empty():
		return

	events.clear()

	history_changed.emit()


func get_event_count() -> int:
	return events.size()


# -------------------------------------------------------------------
# Crawler events
# -------------------------------------------------------------------

func _on_crawler_state_changed(
	is_running: bool
) -> void:
	
	if ObjectiveManager.suppress_objective_evaluation:
		return
	var job_name: String = (
		get_current_crawl_job_name()
	)

	if is_running:
		add_event(
			"Crawler started: %s"
			% job_name,
			&"crawler"
		)

		return

	var pages_processed: int = (
		CrawlerManager.current_job_pages
	)

	var target_pages: int = (
		CrawlerManager.get_current_job_target_pages()
	)

	if CrawlerManager.paused_for_overload:
		add_event(
			"Crawler auto-paused due to server overload.",
			&"warning"
		)

		return

	if (
		pages_processed > 0
		and pages_processed < target_pages
	):
		add_event(
			"Crawler paused: %s"
			% job_name,
			&"crawler"
		)


func _on_crawl_job_completed() -> void:
	var job_name: String = (
		get_current_crawl_job_name()
	)

	var pages_processed: int = (
		CrawlerManager.current_job_pages
	)

	add_event(
		"%s completed — %d pages indexed."
		% [
			job_name,
			pages_processed
		],
		&"success"
	)


func get_current_crawl_job_name() -> String:
	var job_id: StringName = (
		CrawlerManager.selected_job_id
	)

	match job_id:
		&"basic":
			return "Basic Crawl"

		&"expanded":
			return "Expanded Crawl"

		&"deep":
			return "Deep Crawl"

	return "Crawl Job"


# -------------------------------------------------------------------
# Server upgrade events
# -------------------------------------------------------------------

func _on_server_upgrade_purchased(
	_upgrade_id: StringName,
	new_level: int,
	_revenue_spent: float
) -> void:
	add_event(
		"Server upgrade purchased — Level %d."
		% new_level,
		&"server"
	)


# -------------------------------------------------------------------
# Research events
# -------------------------------------------------------------------

func _on_research_upgrade_purchased(
	upgrade_id: StringName,
	new_level: int,
	_research_points_spent: float
) -> void:
	var upgrade_name: String = (
		ResearchManager.get_upgrade_name(
			upgrade_id
		)
	)

	add_event(
		"%s researched to Level %d."
		% [
			upgrade_name,
			new_level
		],
		&"research"
	)


# -------------------------------------------------------------------
# Objective events
# -------------------------------------------------------------------

func _on_objective_completed(
	_objective_id: StringName,
	title: String
) -> void:
	add_event(
		"Objective Complete: %s"
		% title,
		&"objective"
	)


# -------------------------------------------------------------------
# Progression events
# -------------------------------------------------------------------

func _on_progression_tier_changed(
	new_tier: int
) -> void:
	# Ignore progression changes caused by save restoration.
	# We still update our known tier so the EventLogManager
	# has the correct state after loading.
	if ObjectiveManager.suppress_objective_evaluation:
		known_progression_tier = new_tier
		return

	if new_tier <= known_progression_tier:
		known_progression_tier = new_tier
		return

	known_progression_tier = new_tier

	add_event(
		"Progression Tier %d unlocked."
		% new_tier,
		&"progression"
	)
