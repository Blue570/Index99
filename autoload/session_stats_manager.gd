extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal session_statistics_changed

signal session_time_changed(
	total_seconds: int
)


# -------------------------------------------------------------------
# Session Statistics
# -------------------------------------------------------------------

var session_time_seconds: float = 0.0

var pages_indexed: int = 0
var revenue_earned: float = 0.0
var active_users_gained: int = 0

var crawls_completed: int = 0
var manual_assists_used: int = 0
var auto_throttle_actions: int = 0

var last_emitted_session_second: int = -1


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_session_stat_signals()


func connect_session_stat_signals() -> void:
	if not CrawlerManager.crawler_tick_completed.is_connected(
		_on_crawler_tick_completed
	):
		CrawlerManager.crawler_tick_completed.connect(
			_on_crawler_tick_completed
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed
		)

	if not CrawlerManager.manual_crawl_assist_used.is_connected(
		_on_manual_crawl_assist_used
	):
		CrawlerManager.manual_crawl_assist_used.connect(
			_on_manual_crawl_assist_used
		)

	if not AutomationManager.auto_throttle_intervention_performed.is_connected(
		_on_auto_throttle_intervention_performed
	):
		AutomationManager.auto_throttle_intervention_performed.connect(
			_on_auto_throttle_intervention_performed
		)

	if not CrawlerEventManager.crawler_event_resolved.is_connected(
		_on_crawler_event_resolved
	):
		CrawlerEventManager.crawler_event_resolved.connect(
			_on_crawler_event_resolved
		)


# -------------------------------------------------------------------
# Session Time
# -------------------------------------------------------------------

func _process(delta: float) -> void:
	session_time_seconds += delta

	var current_second: int = floori(
		session_time_seconds
	)

	if current_second == last_emitted_session_second:
		return

	last_emitted_session_second = current_second

	session_time_changed.emit(
		current_second
	)


# -------------------------------------------------------------------
# Crawler Statistics
# -------------------------------------------------------------------

func _on_crawler_tick_completed(
	pages_added: int,
	revenue_added: float,
	active_users_added: int
) -> void:
	pages_indexed += maxi(
		pages_added,
		0
	)

	revenue_earned += maxf(
		revenue_added,
		0.0
	)

	active_users_gained += maxi(
		active_users_added,
		0
	)

	session_statistics_changed.emit()


func _on_crawl_job_completed() -> void:
	crawls_completed += 1

	session_statistics_changed.emit()


func _on_manual_crawl_assist_used() -> void:
	manual_assists_used += 1

	session_statistics_changed.emit()


# -------------------------------------------------------------------
# Auto-Throttle Statistics
# -------------------------------------------------------------------

func _on_auto_throttle_intervention_performed() -> void:
	auto_throttle_actions += 1

	session_statistics_changed.emit()


# -------------------------------------------------------------------
# Crawler Event Statistics
# -------------------------------------------------------------------

func _on_crawler_event_resolved(
	event_id: StringName,
	action_id: StringName
) -> void:
	if action_id != CrawlerEventManager.ACTION_PRIMARY:
		return

	match event_id:
		CrawlerEventManager.EVENT_COMMERCIAL_TREND:
			revenue_earned += (
				CrawlerEventManager
				.COMMERCIAL_TREND_REVENUE_REWARD
			)

		CrawlerEventManager.EVENT_USER_CLUSTER:
			active_users_gained += (
				CrawlerEventManager
				.USER_CLUSTER_USER_REWARD
			)

		_:
			return

	session_statistics_changed.emit()


# -------------------------------------------------------------------
# Getters
# -------------------------------------------------------------------

func get_session_time_seconds() -> int:
	return floori(
		session_time_seconds
	)


func get_pages_indexed() -> int:
	return pages_indexed


func get_revenue_earned() -> float:
	return revenue_earned


func get_active_users_gained() -> int:
	return active_users_gained


func get_crawls_completed() -> int:
	return crawls_completed


func get_manual_assists_used() -> int:
	return manual_assists_used


func get_auto_throttle_actions() -> int:
	return auto_throttle_actions
