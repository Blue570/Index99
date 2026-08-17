extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal notification_queued


# -------------------------------------------------------------------
# Notification types
# -------------------------------------------------------------------

const TYPE_INFORMATION: StringName = &"information"
const TYPE_SUCCESS: StringName = &"success"
const TYPE_WARNING: StringName = &"warning"
const TYPE_ERROR: StringName = &"error"
const TYPE_UNLOCK: StringName = &"unlock"


# -------------------------------------------------------------------
# Settings
# -------------------------------------------------------------------

const DEFAULT_DURATION_SECONDS: float = 4.0
const MAX_QUEUED_NOTIFICATIONS: int = 10


# -------------------------------------------------------------------
# Queue
# -------------------------------------------------------------------

var notification_queue: Array[Dictionary] = []


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	call_deferred(
		"connect_notification_signals"
	)

	print(
		"NotificationManager loaded successfully."
	)


# -------------------------------------------------------------------
# Queue management
# -------------------------------------------------------------------

func show_notification(
	title: String,
	message: String,
	notification_type: StringName = TYPE_INFORMATION,
	duration: float = DEFAULT_DURATION_SECONDS
) -> void:
	var clean_title: String = title.strip_edges()
	var clean_message: String = message.strip_edges()

	if clean_title.is_empty():
		return

	if clean_message.is_empty():
		return

	var notification_data: Dictionary = {
		"title": clean_title,
		"message": clean_message,
		"type": notification_type,
		"duration": maxf(
			duration,
			1.0
		)
	}

	notification_queue.append(
		notification_data
	)

	while (
		notification_queue.size()
		> MAX_QUEUED_NOTIFICATIONS
	):
		notification_queue.pop_front()

	notification_queued.emit()


func has_pending_notifications() -> bool:
	return not notification_queue.is_empty()


func take_next_notification() -> Dictionary:
	if notification_queue.is_empty():
		return {}

	return notification_queue.pop_front()


func clear_notifications() -> void:
	notification_queue.clear()


# -------------------------------------------------------------------
# Gameplay signal connections
# -------------------------------------------------------------------

func connect_notification_signals() -> void:
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

	if not ResearchManager.research_upgrade_purchased.is_connected(
		_on_research_upgrade_purchased
	):
		ResearchManager.research_upgrade_purchased.connect(
			_on_research_upgrade_purchased
		)

	if not ServerManager.server_upgrade_purchased.is_connected(
		_on_server_upgrade_purchased
	):
		ServerManager.server_upgrade_purchased.connect(
			_on_server_upgrade_purchased
		)

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


# -------------------------------------------------------------------
# Objective notifications
# -------------------------------------------------------------------

func _on_objective_completed(
	_objective_id: StringName,
	title: String
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	show_notification(
		"OBJECTIVE COMPLETE",
		"%s\n+%d Research Points"
		% [
			title,
			roundi(
				ResearchManager.OBJECTIVE_COMPLETION_REWARD
			)
		],
		TYPE_SUCCESS,
		4.5
	)


# -------------------------------------------------------------------
# Progression notifications
# -------------------------------------------------------------------

func _on_progression_tier_changed(
	new_tier: int
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	if new_tier != ObjectiveManager.PROGRESSION_TIER_2:
		return

	show_notification(
		"NEW CONTENT UNLOCKED",
		(
			"Tier 2 Available\n"
			+ "Expanded Crawl • Deep Crawl\n"
			+ "Tier 2 Server & Research Upgrades"
		),
		TYPE_UNLOCK,
		6.0
	)


# -------------------------------------------------------------------
# Research notifications
# -------------------------------------------------------------------

func _on_research_upgrade_purchased(
	upgrade_id: StringName,
	new_level: int,
	_research_points_spent: float
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	var upgrade_name: String = (
		ResearchManager.get_upgrade_name(
			upgrade_id
		)
	)

	show_notification(
		"RESEARCH COMPLETE",
		"%s\nLevel %d"
		% [
			upgrade_name,
			new_level
		],
		TYPE_SUCCESS
	)


# -------------------------------------------------------------------
# Server notifications
# -------------------------------------------------------------------

func _on_server_upgrade_purchased(
	upgrade_id: StringName,
	new_level: int,
	_revenue_spent: float
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	var upgrade_name: String = (
		str(upgrade_id)
		.replace(
			"_",
			" "
		)
		.capitalize()
	)

	show_notification(
		"SERVER UPGRADE",
		"%s\nLevel %d"
		% [
			upgrade_name,
			new_level
		],
		TYPE_SUCCESS
	)


# -------------------------------------------------------------------
# Crawler notifications
# -------------------------------------------------------------------

func _on_crawler_state_changed(
	is_running: bool
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	if is_running:
		return

	if not CrawlerManager.paused_for_overload:
		return

	show_notification(
		"SERVER LOAD CRITICAL",
		(
			"Crawler automatically paused.\n"
			+ "Server cooling is in progress."
		),
		TYPE_WARNING,
		5.0
	)


func _on_crawl_job_completed() -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	show_notification(
		"CRAWL COMPLETE",
		"%s completed successfully."
		% CrawlerManager.get_selected_job_display_name(),
		TYPE_SUCCESS
	)
