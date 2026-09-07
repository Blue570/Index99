extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal crawler_event_started(
	event_data: Dictionary
)

signal crawler_event_cleared

signal crawler_event_expired(
	event_id: StringName
)

signal crawler_event_resolved(
	event_id: StringName,
	action_id: StringName
)


# -------------------------------------------------------------------
# Event identifiers
# -------------------------------------------------------------------

const EVENT_HIGH_TRAFFIC_DOMAIN: StringName = (
	&"high_traffic_domain"
)

const EVENT_COMMERCIAL_TREND: StringName = (
	&"commercial_trend"
)

const EVENT_USER_CLUSTER: StringName = (
	&"user_cluster"
)

const EVENT_CLEAN_CRAWL_PATH: StringName = (
	&"clean_crawl_path"
)

const ACTION_PRIMARY: StringName = &"primary"
const ACTION_SECONDARY: StringName = &"secondary"


# -------------------------------------------------------------------
# Event effect balance
# -------------------------------------------------------------------

const HIGH_TRAFFIC_WORK_REWARD: float = 8.0
const HIGH_TRAFFIC_LOAD_COST: float = 5.0

const COMMERCIAL_TREND_REVENUE_REWARD: float = 15.0
const COMMERCIAL_TREND_LOAD_COST: float = 4.0

const USER_CLUSTER_USER_REWARD: int = 3
const USER_CLUSTER_LOAD_COST: float = 5.0

const CLEAN_CRAWL_PATH_WORK_REWARD: float = 6.0


# -------------------------------------------------------------------
# Event timing
# -------------------------------------------------------------------

const MIN_EVENT_DELAY_SECONDS: float = 5.0
const MAX_EVENT_DELAY_SECONDS: float = 8.0

const EVENT_RESPONSE_DURATION_SECONDS: float = 12.0


# -------------------------------------------------------------------
# Event definitions
#
# Effects will be added later.
# For now this only defines what the event is and
# what choices will eventually appear in the UI.
# -------------------------------------------------------------------

const CRAWLER_EVENTS: Array[Dictionary] = [
	{
		"id": EVENT_HIGH_TRAFFIC_DOMAIN,
		"title": "HIGH-TRAFFIC DOMAIN FOUND",
		"description":
			"A heavily linked domain has been discovered.",
		"primary_action": "Prioritize",
		"primary_effect_text":
			"+8 WORK | +5 SERVER LOAD",
		"secondary_action": "Skip",
		"secondary_effect_text":
			"No effect"
	},
	{
		"id": EVENT_COMMERCIAL_TREND,
		"title": "COMMERCIAL SEARCH TREND",
		"description":
			"Commercial search activity is increasing.",
		"primary_action": "Index Now",
		"primary_effect_text":
			"+$15 REVENUE | +4 SERVER LOAD",
		"secondary_action": "Ignore",
		"secondary_effect_text":
			"No effect"
	},
	{
		"id": EVENT_USER_CLUSTER,
		"title": "NEW USER CLUSTER",
		"description":
			"A new group of users is discovering the index.",
		"primary_action": "Analyze",
		"primary_effect_text":
			"+3 ACTIVE USERS | +5 SERVER LOAD",
		"secondary_action": "Continue",
		"secondary_effect_text":
			"No effect"
	},
	{
		"id": EVENT_CLEAN_CRAWL_PATH,
		"title": "CLEAN CRAWL PATH",
		"description":
			"The crawler found an unusually efficient path.",
		"primary_action": "Use Path",
		"primary_effect_text":
			"+6 WORK | NO EXTRA LOAD",
		"secondary_action": "Continue",
		"secondary_effect_text":
			"No effect"
	}
]


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var event_spawn_timer: Timer
var event_response_timer: Timer

var active_event: Dictionary = {}
var last_event_result: Dictionary = {}

var last_event_id: StringName = &""

var random_generator: RandomNumberGenerator = (
	RandomNumberGenerator.new()
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	random_generator.randomize()

	create_event_spawn_timer()
	create_event_response_timer()

	connect_crawler_signals()

	call_deferred(
		"synchronize_event_generation"
	)


func create_event_spawn_timer() -> void:
	event_spawn_timer = Timer.new()

	event_spawn_timer.name = (
		"CrawlerEventSpawnTimer"
	)

	event_spawn_timer.one_shot = true
	event_spawn_timer.autostart = false

	add_child(
		event_spawn_timer
	)

	event_spawn_timer.timeout.connect(
		_on_event_spawn_timer_timeout
	)


func create_event_response_timer() -> void:
	event_response_timer = Timer.new()

	event_response_timer.name = (
		"CrawlerEventResponseTimer"
	)

	event_response_timer.one_shot = true
	event_response_timer.autostart = false

	add_child(
		event_response_timer
	)

	event_response_timer.timeout.connect(
		_on_event_response_timer_timeout
	)


# -------------------------------------------------------------------
# Crawler connections
# -------------------------------------------------------------------

func connect_crawler_signals() -> void:
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


func _on_crawler_state_changed(
	is_running: bool
) -> void:
	if is_running:
		synchronize_event_generation()
		return

	cancel_event_generation()


func _on_crawl_job_completed() -> void:
	cancel_event_generation()


# -------------------------------------------------------------------
# Event generation
# -------------------------------------------------------------------

func synchronize_event_generation() -> void:
	if not can_generate_event():
		return

	if not active_event.is_empty():
		return

	if not event_spawn_timer.is_stopped():
		return

	schedule_next_event()


func can_generate_event() -> bool:
	if not GameState.crawler_running:
		return false

	if CrawlerManager.paused_for_overload:
		return false

	if CrawlerManager.is_current_job_complete():
		return false

	return true


func schedule_next_event() -> void:
	if not can_generate_event():
		return

	if not active_event.is_empty():
		return

	var delay_seconds: float = (
		random_generator.randf_range(
			MIN_EVENT_DELAY_SECONDS,
			MAX_EVENT_DELAY_SECONDS
		)
	)

	event_spawn_timer.start(
		delay_seconds
	)

	print(
		"CrawlerEventManager: next event in %.1f seconds"
		% delay_seconds
	)


func _on_event_spawn_timer_timeout() -> void:
	if not can_generate_event():
		return

	start_random_event()


# -------------------------------------------------------------------
# Event selection
# -------------------------------------------------------------------

func start_random_event() -> void:
	if CRAWLER_EVENTS.is_empty():
		return

	if not active_event.is_empty():
		return

	var selected_event: Dictionary = (
		select_random_event()
	)

	if selected_event.is_empty():
		return

	active_event = selected_event.duplicate(
		true
	)

	var event_id: StringName = StringName(
		active_event.get(
			"id",
			&""
		)
	)

	last_event_id = event_id

	event_response_timer.start(
		EVENT_RESPONSE_DURATION_SECONDS
	)

	print(
		"CrawlerEventManager: event started - ",
		active_event.get(
			"title",
			"Unknown Event"
		)
	)

	crawler_event_started.emit(
		active_event.duplicate(true)
	)


func select_random_event() -> Dictionary:
	if CRAWLER_EVENTS.size() == 1:
		return CRAWLER_EVENTS[0]

	var selected_index: int = (
		random_generator.randi_range(
			0,
			CRAWLER_EVENTS.size() - 1
		)
	)

	var selected_event: Dictionary = (
		CRAWLER_EVENTS[selected_index]
	)

	var selected_id: StringName = StringName(
		selected_event.get(
			"id",
			&""
		)
	)

	var retry_count: int = 0

	while (
		selected_id == last_event_id
		and retry_count < 5
	):
		selected_index = (
			random_generator.randi_range(
				0,
				CRAWLER_EVENTS.size() - 1
			)
		)

		selected_event = (
			CRAWLER_EVENTS[selected_index]
		)

		selected_id = StringName(
			selected_event.get(
				"id",
				&""
			)
		)

		retry_count += 1

	return selected_event


# -------------------------------------------------------------------
# Event expiration
# -------------------------------------------------------------------

func _on_event_response_timer_timeout() -> void:
	if active_event.is_empty():
		return

	var expired_event_id: StringName = StringName(
		active_event.get(
			"id",
			&""
		)
	)

	print(
		"CrawlerEventManager: event expired - ",
		active_event.get(
			"title",
			"Unknown Event"
		)
	)

	active_event.clear()

	crawler_event_expired.emit(
		expired_event_id
	)

	crawler_event_cleared.emit()

	synchronize_event_generation()


# -------------------------------------------------------------------
# Event state
# -------------------------------------------------------------------

func has_active_event() -> bool:
	return not active_event.is_empty()


func get_active_event() -> Dictionary:
	return active_event.duplicate(
		true
	)
	
func get_last_event_result() -> Dictionary:
	return last_event_result.duplicate(
		true
	)


func get_event_time_remaining() -> float:
	if active_event.is_empty():
		return 0.0

	return maxf(
		event_response_timer.time_left,
		0.0
	)


# -------------------------------------------------------------------
# Clearing / reset
# -------------------------------------------------------------------

func clear_active_event() -> void:
	event_response_timer.stop()

	if active_event.is_empty():
		return

	active_event.clear()

	crawler_event_cleared.emit()


func cancel_event_generation() -> void:
	event_spawn_timer.stop()
	event_response_timer.stop()

	if not active_event.is_empty():
		active_event.clear()

		crawler_event_cleared.emit()


func reset_crawler_events() -> void:
	event_spawn_timer.stop()
	event_response_timer.stop()

	active_event.clear()
	last_event_result.clear()

	last_event_id = &""
	
	
	
# -------------------------------------------------------------------
# Event effects
# -------------------------------------------------------------------

func apply_primary_event_effect(
	event_id: StringName
) -> Dictionary:
	match event_id:
		EVENT_HIGH_TRAFFIC_DOMAIN:
			return apply_high_traffic_domain_effect()

		EVENT_COMMERCIAL_TREND:
			return apply_commercial_trend_effect()

		EVENT_USER_CLUSTER:
			return apply_user_cluster_effect()

		EVENT_CLEAN_CRAWL_PATH:
			return apply_clean_crawl_path_effect()

	return {
		"title": "EVENT RESOLVED",
		"message": "No effect was applied.",
		"primary": true
	}


func apply_high_traffic_domain_effect() -> Dictionary:
	var work_added: int = (
		CrawlerManager.apply_crawler_event_work(
			HIGH_TRAFFIC_WORK_REWARD
		)
	)

	var load_added: float = (
		CrawlerManager.apply_crawler_event_server_load(
			HIGH_TRAFFIC_LOAD_COST
		)
	)

	return {
		"title": "EVENT RESOLVED",
		"message":
			"+%d WORK | +%.0f SERVER LOAD"
			% [
				work_added,
				load_added
			],
		"primary": true
	}


func apply_commercial_trend_effect() -> Dictionary:
	GameState.set_revenue(
		GameState.revenue
		+ COMMERCIAL_TREND_REVENUE_REWARD
	)

	var load_added: float = (
		CrawlerManager.apply_crawler_event_server_load(
			COMMERCIAL_TREND_LOAD_COST
		)
	)

	return {
		"title": "EVENT RESOLVED",
		"message":
			"+$%.0f REVENUE | +%.0f SERVER LOAD"
			% [
				COMMERCIAL_TREND_REVENUE_REWARD,
				load_added
			],
		"primary": true
	}


func apply_user_cluster_effect() -> Dictionary:
	GameState.set_active_users(
		GameState.active_users
		+ USER_CLUSTER_USER_REWARD
	)

	var load_added: float = (
		CrawlerManager.apply_crawler_event_server_load(
			USER_CLUSTER_LOAD_COST
		)
	)

	return {
		"title": "EVENT RESOLVED",
		"message":
			"+%d ACTIVE USERS | +%.0f SERVER LOAD"
			% [
				USER_CLUSTER_USER_REWARD,
				load_added
			],
		"primary": true
	}


func apply_clean_crawl_path_effect() -> Dictionary:
	var work_added: int = (
		CrawlerManager.apply_crawler_event_work(
			CLEAN_CRAWL_PATH_WORK_REWARD
		)
	)

	return {
		"title": "EVENT RESOLVED",
		"message":
			"+%d WORK | NO EXTRA LOAD"
			% work_added,
		"primary": true
	}
	

# -------------------------------------------------------------------
# Event resolution
# -------------------------------------------------------------------

func resolve_active_event(
	action_id: StringName
) -> bool:
	if active_event.is_empty():
		return false

	if (
		action_id != ACTION_PRIMARY
		and action_id != ACTION_SECONDARY
	):
		return false

	var resolved_event: Dictionary = (
		active_event.duplicate(true)
	)

	var event_id: StringName = StringName(
		resolved_event.get(
			"id",
			&""
		)
	)

	var event_title: String = str(
		resolved_event.get(
			"title",
			"Unknown Event"
		)
	)

	event_response_timer.stop()

	# Clear the active event before applying effects.
	# An effect may complete the crawl or trigger an
	# overload, both of which can emit crawler signals.
	active_event.clear()

	crawler_event_cleared.emit()

	if action_id == ACTION_PRIMARY:
		last_event_result = (
			apply_primary_event_effect(
				event_id
			)
		)

	else:
		last_event_result = {
			"title": "EVENT PASSED",
			"message": "No changes applied.",
			"primary": false
		}

	print(
		"CrawlerEventManager: event resolved - ",
		event_title,
		" | Action: ",
		action_id,
		" | Result: ",
		last_event_result.get(
			"message",
			"No result"
		)
	)

	crawler_event_resolved.emit(
		event_id,
		action_id
	)

	synchronize_event_generation()

	return true
