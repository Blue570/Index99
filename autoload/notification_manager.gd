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
const TYPE_REWARD: StringName = &"reward"


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
		
	if not ResearchManager.research_points_awarded.is_connected(
		_on_research_points_awarded
	):
		ResearchManager.research_points_awarded.connect(
			_on_research_points_awarded
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

func _on_research_points_awarded(
	amount: float,
	source: String
) -> void:
	if ObjectiveManager.suppress_objective_evaluation:
		return

	if ResearchManager.suppress_milestone_rewards:
		return

	if not source.begins_with(
		"Indexed "
	):
		return

	if not source.ends_with(
		" Pages"
	):
		return

	var milestone_pages: int = (
		get_indexed_page_milestone_from_source(
			source
		)
	)

	if milestone_pages <= 0:
		return

	if milestone_pages > 100:
		return

	show_indexed_page_milestone_notification(
		milestone_pages,
		amount
	)
	
func get_indexed_page_milestone_from_source(
	source: String
) -> int:
	var source_parts: PackedStringArray = (
		source.split(
			" "
		)
	)

	if source_parts.size() != 3:
		return -1

	return int(
		source_parts[1]
	)
	
func show_indexed_page_milestone_notification(
	milestone_pages: int,
	reward_amount: float
) -> void:
	var rounded_reward: int = roundi(
		reward_amount
	)

	var reward_text: String = (
		"+%d Research Point"
		% rounded_reward
	)

	if rounded_reward != 1:
		reward_text += "s"

	var message: String = (
		"Indexed %d Pages\n%s"
		% [
			milestone_pages,
			reward_text
		]
	)

	var duration: float = 3.5

	if milestone_pages == 75:
		if (
			ResearchManager.get_upgrade_level(
				ResearchManager
				.UPGRADE_CRAWLER_OPTIMIZATION
			) == 0
			and ResearchManager.can_afford_upgrade(
				ResearchManager
					.UPGRADE_CRAWLER_OPTIMIZATION
			)
		):
			message += (
				"\nCrawler Optimization is now purchasable."
			)

			duration = 4.5

	elif milestone_pages == 100:
		duration = 4.5

	show_notification(
		"INDEX MILESTONE",
		message,
		TYPE_REWARD,
		duration
	)


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
		get_server_upgrade_display_name(
			upgrade_id
		)
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
	
func get_server_upgrade_display_name(
	upgrade_id: StringName
) -> String:
	var upgrade_key: String = str(
		upgrade_id
	)

	match upgrade_key:
		"cooling_speed":
			return "Improved Cooling"

		"crawler_efficiency":
			return "Efficient Crawling"

		"maximum_safe_load":
			return "Load Buffering"

		"improved_cooling":
			return "Improved Cooling"

		"efficient_crawling":
			return "Efficient Crawling"

		"load_buffering":
			return "Load Buffering"

	return (
		upgrade_key
		.replace(
			"_",
			" "
		)
		.capitalize()
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
