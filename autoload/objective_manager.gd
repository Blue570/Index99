extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal objective_changed(
	objective_id: StringName,
	title: String,
	description: String,
	current_value: int,
	target_value: int
)

signal objective_progress_changed(
	current_value: int,
	target_value: int
)

signal objective_completed(
	objective_id: StringName,
	title: String
)

signal all_objectives_completed

signal progression_tier_changed(
	new_tier: int
)

signal tier_2_active_objectives_changed

signal tier_2_objective_progress_changed(
	objective_id: StringName,
	current_value: float,
	target_value: float
)

signal tier_2_standard_objectives_completed


# -------------------------------------------------------------------
# Objective identifiers
# -------------------------------------------------------------------

const OBJECTIVE_INDEX_100_PAGES: StringName = (
	&"index_100_pages"
)

const OBJECTIVE_REACH_40_USERS: StringName = (
	&"reach_40_active_users"
)

const OBJECTIVE_PURCHASE_SERVER_UPGRADE: StringName = (
	&"purchase_server_upgrade"
)

const OBJECTIVE_COMPLETE_RESEARCH: StringName = (
	&"complete_research_upgrade"
)

const OBJECTIVE_INDEX_500_PAGES: StringName = (
	&"index_500_pages"
)

const OBJECTIVE_COMPLETE_EXPANDED_CRAWL: StringName = (
	&"complete_expanded_crawl"
)

const OBJECTIVE_INDEX_1000_PAGES: StringName = (
	&"index_1000_pages"
)

const OBJECTIVE_REACH_100_USERS: StringName = (
	&"reach_100_active_users"
)

const OBJECTIVE_PURCHASE_TIER_2_SERVER_UPGRADE: StringName = (
	&"purchase_tier_2_server_upgrade"
)

const OBJECTIVE_COMPLETE_TIER_2_RESEARCH: StringName = (
	&"complete_tier_2_research"
)

const OBJECTIVE_INDEX_2000_PAGES: StringName = (
	&"index_2000_pages"
)

const TIER_1_OBJECTIVE_COUNT: int = 5


# -------------------------------------------------------------------
# Tier 2 Objective Identifiers
# -------------------------------------------------------------------

const OBJECTIVE_T2_INDEX_2000_PAGES: StringName = (
	&"tier_2_index_2000_pages"
)

const OBJECTIVE_T2_REACH_150_USERS: StringName = (
	&"tier_2_reach_150_users"
)

const OBJECTIVE_T2_COMPLETE_3_ACTIVITIES: StringName = (
	&"tier_2_complete_3_activities"
)

const OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS: StringName = (
	&"tier_2_purchase_3_server_levels"
)

const OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS: StringName = (
	&"tier_2_purchase_2_research_levels"
)

const OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS: StringName = (
	&"tier_2_complete_2_expanded_crawls"
)

const OBJECTIVE_T2_EARN_250_REVENUE: StringName = (
	&"tier_2_earn_250_revenue"
)

const OBJECTIVE_T2_CAPSTONE: StringName = (
	&"tier_2_expanded_operations_test"
)


# -------------------------------------------------------------------
# Objective sequence
# -------------------------------------------------------------------

const OBJECTIVES: Array[Dictionary] = [
	{
		"id": OBJECTIVE_INDEX_100_PAGES,
		"title": "Index 100 Pages",
		"description": "Grow the search index to 100 total pages.",
		"target": 100
	},
	{
		"id": OBJECTIVE_REACH_40_USERS,
		"title": "Reach 40 Active Users",
		"description": "Build an audience of 40 active users.",
		"target": 40
	},
	{
		"id": OBJECTIVE_PURCHASE_SERVER_UPGRADE,
		"title": "Purchase a Server Upgrade",
		"description": "Purchase a server upgrade while this objective is active.",
		"target": 1
	},
	{
		"id": OBJECTIVE_COMPLETE_RESEARCH,
		"title": "Complete a Research Upgrade",
		"description": "Purchase a research upgrade while this objective is active.",
		"target": 1
	},
	{
		"id": OBJECTIVE_INDEX_500_PAGES,
		"title": "Index 500 Pages",
		"description": "Grow the search index to 500 total pages.",
		"target": 500
	},
	{
		"id": OBJECTIVE_COMPLETE_EXPANDED_CRAWL,
		"title": "Complete an Expanded Crawl",
		"description": "Complete one 250-page Expanded Crawl.",
		"target": 1
	},
	{
		"id": OBJECTIVE_INDEX_1000_PAGES,
		"title": "Index 1,000 Pages",
		"description": "Grow the search index to 1,000 total pages.",
		"target": 1000
	},
	{
		"id": OBJECTIVE_REACH_100_USERS,
		"title": "Reach 100 Active Users",
		"description": "Build an audience of 100 active users.",
		"target": 100
	},
	{
		"id": OBJECTIVE_PURCHASE_TIER_2_SERVER_UPGRADE,
		"title": "Upgrade Server Infrastructure",
		"description": "Reach Level 3 on any server upgrade.",
		"target": 1
	},
	{
		"id": OBJECTIVE_COMPLETE_TIER_2_RESEARCH,
		"title": "Advance Research",
		"description": "Reach Level 2 on any research upgrade.",
		"target": 1
	},
	{
		"id": OBJECTIVE_INDEX_2000_PAGES,
		"title": "Index 2,000 Pages",
		"description": "Grow the search index to 2,000 total pages.",
		"target": 2000
	}
]

# -------------------------------------------------------------------
# Tier 2 Objectives
# -------------------------------------------------------------------

const TIER_2_OBJECTIVES: Array[Dictionary] = [
	{
		"id": OBJECTIVE_T2_INDEX_2000_PAGES,
		"title": "Index 2,000 Pages",
		"description": (
			"Grow the search index to 2,000 total pages."
		),
		"target": 2000
	},
	{
		"id": OBJECTIVE_T2_REACH_150_USERS,
		"title": "Reach 150 Active Users",
		"description": (
			"Grow the active audience to 150 users."
		),
		"target": 150
	},
	{
		"id": OBJECTIVE_T2_COMPLETE_3_ACTIVITIES,
		"title": "Complete 3 Activities",
		"description": (
			"Complete three Activities during Tier 2."
		),
		"target": 3
	},
	{
		"id": OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS,
		"title": "Purchase 3 Server Upgrade Levels",
		"description": (
			"Purchase three Server upgrade levels "
			+ "during Tier 2."
		),
		"target": 3
	},
	{
		"id": OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS,
		"title": "Purchase 2 Research Upgrade Levels",
		"description": (
			"Purchase two Research upgrade levels "
			+ "during Tier 2."
		),
		"target": 2
	},
	{
		"id": OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS,
		"title": "Complete 2 Expanded Crawl Jobs",
		"description": (
			"Successfully complete two Expanded Crawls."
		),
		"target": 2
	},
	{
		"id": OBJECTIVE_T2_EARN_250_REVENUE,
		"title": "Earn $250 Revenue During Tier",
		"description": (
			"Generate $250 in new revenue during Tier 2."
		),
		"target": 250.0
	}
]

# -------------------------------------------------------------------
# Progression Tiers
# -------------------------------------------------------------------

const PROGRESSION_TIER_1: int = 1
const PROGRESSION_TIER_2: int = 2
const MAX_PROGRESSION_TIER: int = 2


# -------------------------------------------------------------------
# Objective state
# -------------------------------------------------------------------

var current_objective_index: int = 0

var current_event_progress: int = 0

var sequence_completed: bool = false

var suppress_objective_evaluation: bool = false
var objective_completion_in_progress: bool = false

var current_progression_tier: int = (
	PROGRESSION_TIER_1
)

const TIER_2_MAX_ACTIVE_OBJECTIVES: int = 2

const TIER_2_OBJECTIVE_ORDER: Array[StringName] = [
	OBJECTIVE_T2_INDEX_2000_PAGES,
	OBJECTIVE_T2_COMPLETE_3_ACTIVITIES,
	OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS,
	OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS,
	OBJECTIVE_T2_REACH_150_USERS,
	OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS,
	OBJECTIVE_T2_EARN_250_REVENUE
]

var tier_2_reward_in_progress: bool = false

# -------------------------------------------------------------------
# Tier 2 Tracking State
# -------------------------------------------------------------------

var tier_2_tracking_started: bool = false

var tier_2_activities_completed: int = 0

var tier_2_server_upgrade_levels_purchased: int = 0

var tier_2_research_upgrade_levels_purchased: int = 0

var tier_2_expanded_crawls_completed: int = 0

var tier_2_revenue_earned: float = 0.0

var tier_2_last_observed_revenue: float = 0.0

var suppress_tier_2_revenue_tracking: bool = false

# -------------------------------------------------------------------
# Tier 2 Objective Queue State
# -------------------------------------------------------------------

var tier_2_active_objective_ids: Array[StringName] = []

var tier_2_completed_objectives: Dictionary = {}

var tier_2_next_queue_index: int = 0

var tier_2_standard_objectives_finished: bool = false


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	tier_2_last_observed_revenue = (
		GameState.revenue
	)

	call_deferred(
		"initialize_objectives"
	)
	
func initialize_objectives() -> void:
	connect_objective_signals()

	activate_current_objective()

# -------------------------------------------------------------------
# Signal connections
# -------------------------------------------------------------------

func connect_objective_signals() -> void:
	if not GameState.indexed_pages_changed.is_connected(
		_on_indexed_pages_changed
	):
		GameState.indexed_pages_changed.connect(
			_on_indexed_pages_changed
		)

	if not GameState.active_users_changed.is_connected(
		_on_active_users_changed
	):
		GameState.active_users_changed.connect(
			_on_active_users_changed
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
	
	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed
	):
			CrawlerManager.crawl_job_completed.connect(
				_on_crawl_job_completed
		)
		
	if not ActivityStatsManager.activity_completed.is_connected(
		_on_activity_completed_for_tier_2
	):
		ActivityStatsManager.activity_completed.connect(
			_on_activity_completed_for_tier_2
		)
		
	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_tier_2
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_tier_2
		)
		
	if not GameState.revenue_changed.is_connected(
		_on_revenue_changed_for_tier_2
	):
		GameState.revenue_changed.connect(
			_on_revenue_changed_for_tier_2
		)


# -------------------------------------------------------------------
# Current objective information
# -------------------------------------------------------------------

func get_current_objective() -> Dictionary:
	if (
		tier_2_tracking_started
		and current_progression_tier
			>= PROGRESSION_TIER_2
	):
		if tier_2_active_objective_ids.is_empty():
			return {}

		return get_tier_2_objective_by_id(
			tier_2_active_objective_ids[0]
		)

	if sequence_completed:
		return {}

	if (
		current_objective_index < 0
		or current_objective_index
			>= OBJECTIVES.size()
	):
		return {}

	return OBJECTIVES[
		current_objective_index
	]


func get_current_objective_id() -> StringName:
	var objective: Dictionary = (
		get_current_objective()
	)

	if objective.is_empty():
		return &""

	return objective["id"] as StringName


func get_current_objective_title() -> String:
	var objective: Dictionary = (
		get_current_objective()
	)

	if objective.is_empty():
		return ""

	return str(
		objective["title"]
	)


func get_current_objective_description() -> String:
	var objective: Dictionary = (
		get_current_objective()
	)

	if objective.is_empty():
		return ""

	return str(
		objective["description"]
	)


func get_current_objective_target() -> int:
	var objective: Dictionary = (
		get_current_objective()
	)

	if objective.is_empty():
		return 0

	return int(
		objective["target"]
	)
	
func get_objective_index_by_id(
	objective_id: StringName
) -> int:
	for objective_index: int in range(
		OBJECTIVES.size()
	):
		var objective_data: Dictionary = (
			OBJECTIVES[objective_index]
		)

		var stored_id: StringName = StringName(
			objective_data.get(
				"id",
				&""
			)
		)

		if stored_id == objective_id:
			return objective_index

	return -1


func is_server_purchasing_unlocked() -> bool:
	if sequence_completed:
		return true

	var server_purchase_objective_index: int = (
		get_objective_index_by_id(
			OBJECTIVE_PURCHASE_SERVER_UPGRADE
		)
	)

	if server_purchase_objective_index < 0:
		return true

	return (
		current_objective_index
		>= server_purchase_objective_index
	)
	
func is_full_research_purchasing_unlocked() -> bool:
	if sequence_completed:
		return true

	var research_objective_index: int = (
		get_objective_index_by_id(
			OBJECTIVE_COMPLETE_RESEARCH
		)
	)

	if research_objective_index < 0:
		return true

	return (
		current_objective_index
		>= research_objective_index
	)
	
func _on_activity_completed_for_tier_2(
	_activity_type: StringName,
	_type_total: int,
	_overall_total: int
) -> void:
	if not is_tier_2_tracking_active():
		return

	tier_2_activities_completed += 1

	print(
		"Tier 2 Activities: ",
		tier_2_activities_completed,
		" / 3"
	)
	
	evaluate_tier_2_active_objectives()
	
func _on_crawl_job_completed_for_tier_2() -> void:
	if not is_tier_2_tracking_active():
		return

	if (
		CrawlerManager.get_selected_job_id()
		!= CrawlerManager.CRAWL_JOB_EXPANDED
	):
		return

	tier_2_expanded_crawls_completed += 1

	print(
		"Tier 2 Expanded Crawls: ",
		tier_2_expanded_crawls_completed,
		" / 2"
	)

	evaluate_tier_2_active_objectives()


# -------------------------------------------------------------------
# Objective activation
# -------------------------------------------------------------------

func activate_current_objective() -> void:
	if current_objective_index >= OBJECTIVES.size():
		finish_objective_sequence()
		return

	current_event_progress = 0

	emit_current_objective()

	evaluate_current_objective()


func emit_current_objective() -> void:
	if sequence_completed:
		return

	objective_changed.emit(
		get_current_objective_id(),
		get_current_objective_title(),
		get_current_objective_description(),
		get_current_progress(),
		get_current_objective_target()
	)
	
# -------------------------------------------------------------------
# Objective progress
# -------------------------------------------------------------------

func get_current_progress() -> int:
	var objective_id: StringName = (
		get_current_objective_id()
	)
	
	if (
		tier_2_tracking_started
		and current_progression_tier
			>= PROGRESSION_TIER_2
	):
		return floori(
			get_tier_2_objective_progress(
				objective_id
			)
		)

	match objective_id:
		OBJECTIVE_INDEX_100_PAGES:
			return GameState.indexed_pages

		OBJECTIVE_REACH_40_USERS:
			return GameState.active_users

		OBJECTIVE_PURCHASE_SERVER_UPGRADE:
			return current_event_progress

		OBJECTIVE_COMPLETE_RESEARCH:
			return current_event_progress

		OBJECTIVE_INDEX_500_PAGES:
			return GameState.indexed_pages

		OBJECTIVE_COMPLETE_EXPANDED_CRAWL:
			return current_event_progress

		OBJECTIVE_INDEX_1000_PAGES:
			return GameState.indexed_pages

		OBJECTIVE_REACH_100_USERS:
			return GameState.active_users

		OBJECTIVE_PURCHASE_TIER_2_SERVER_UPGRADE:
			if has_completed_tier_2_server_upgrade():
				return 1

			return 0

		OBJECTIVE_COMPLETE_TIER_2_RESEARCH:
			if has_completed_tier_2_research():
				return 1

			return 0

		OBJECTIVE_INDEX_2000_PAGES:
			return GameState.indexed_pages

	return 0
	
func has_completed_tier_2_server_upgrade() -> bool:
	return (
		ServerManager.cooling_speed_level >= 3
		or ServerManager.crawler_efficiency_level >= 3
		or ServerManager.maximum_safe_load_level >= 3
	)
	
func has_completed_tier_2_research() -> bool:
	return (
		ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
		) >= 2
		or ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_SEARCH_MONETIZATION
		) >= 2
		or ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
		) >= 2
	)


func emit_current_progress() -> void:
	if sequence_completed:
		return

	objective_progress_changed.emit(
		get_current_progress(),
		get_current_objective_target()
	)


func evaluate_current_objective() -> void:
	if suppress_objective_evaluation:
		return

	if objective_completion_in_progress:
		return

	if sequence_completed:
		return

	var current_progress: int = (
		get_current_progress()
	)

	var target: int = (
		get_current_objective_target()
	)

	if target <= 0:
		return

	emit_current_progress()

	if current_progress >= target:
		complete_current_objective()
		
func _on_revenue_changed_for_tier_2(
	new_revenue: float
) -> void:
	var previous_revenue: float = (
		tier_2_last_observed_revenue
	)

	tier_2_last_observed_revenue = (
		new_revenue
	)

	if suppress_objective_evaluation:
		return

	if suppress_tier_2_revenue_tracking:
		return

	if not is_tier_2_tracking_active():
		return

	var revenue_increase: float = (
		new_revenue - previous_revenue
	)

	if revenue_increase <= 0.0:
		return

	tier_2_revenue_earned += (
		revenue_increase
	)

	print(
		"Tier 2 Revenue Earned: $%.2f / $250.00"
		% tier_2_revenue_earned
	)
		
	evaluate_tier_2_active_objectives()
		
		
# -------------------------------------------------------------------
# Tier 2 Tracking
# -------------------------------------------------------------------

func begin_tier_2_tracking() -> void:
	if tier_2_tracking_started:
		return

	tier_2_tracking_started = true

	tier_2_activities_completed = 0
	tier_2_server_upgrade_levels_purchased = 0
	tier_2_research_upgrade_levels_purchased = 0
	tier_2_expanded_crawls_completed = 0

	tier_2_revenue_earned = 0.0

	tier_2_last_observed_revenue = (
		GameState.revenue
	)

	print(
		"ObjectiveManager: Tier 2 tracking started."
	)
	
func start_tier_2_objective_sequence() -> void:
	tier_2_active_objective_ids.clear()
	tier_2_completed_objectives.clear()

	tier_2_next_queue_index = 0

	tier_2_standard_objectives_finished = false

	fill_tier_2_active_objective_slots()

	emit_tier_2_active_objectives()

	call_deferred(
		"evaluate_tier_2_active_objectives"
	)

func fill_tier_2_active_objective_slots() -> void:
	while (
		tier_2_active_objective_ids.size()
		< TIER_2_MAX_ACTIVE_OBJECTIVES
		and tier_2_next_queue_index
		< TIER_2_OBJECTIVE_ORDER.size()
	):
		var objective_id: StringName = (
			TIER_2_OBJECTIVE_ORDER[
				tier_2_next_queue_index
			]
		)

		tier_2_next_queue_index += 1

		if tier_2_completed_objectives.has(
			objective_id
		):
			continue

		if tier_2_active_objective_ids.has(
			objective_id
		):
			continue

		tier_2_active_objective_ids.append(
			objective_id
		)
		
func emit_tier_2_active_objectives() -> void:
	tier_2_active_objectives_changed.emit()

	print(
		"ObjectiveManager: Tier 2 active objectives: ",
		tier_2_active_objective_ids
	)

	emit_current_objective()

# -------------------------------------------------------------------
# Completing objectives
# -------------------------------------------------------------------

func complete_current_objective() -> void:
	if sequence_completed:
		return

	if objective_completion_in_progress:
		return

	var objective_id: StringName = (
		get_current_objective_id()
	)

	var objective_title: String = (
		get_current_objective_title()
	)

	if objective_id == &"":
		return

	objective_completion_in_progress = true

	var starting_tier_2: bool = (
		objective_id
		== OBJECTIVE_INDEX_500_PAGES
	)

	if starting_tier_2:
		current_objective_index = (
			TIER_1_OBJECTIVE_COUNT
		)
	else:
		current_objective_index += 1

	ResearchManager.award_objective_completion(
		objective_id,
		objective_title
	)

	objective_completed.emit(
		objective_id,
		objective_title
	)

	if starting_tier_2:
		begin_tier_2_tracking()

		set_progression_tier(
			PROGRESSION_TIER_2
		)

	objective_completion_in_progress = false

	if starting_tier_2:
		start_tier_2_objective_sequence()

		return

	activate_current_objective()
	
func evaluate_tier_2_active_objectives() -> void:
	if suppress_objective_evaluation:
		return
		
	if tier_2_reward_in_progress:
		return

	if not is_tier_2_tracking_active():
		return

	if tier_2_standard_objectives_finished:
		return

	var objective_to_complete: StringName = &""

	for objective_id: StringName in tier_2_active_objective_ids:
		var current_value: float = (
			get_tier_2_objective_progress(
				objective_id
			)
		)

		var target_value: float = (
			get_tier_2_objective_target(
				objective_id
			)
		)

		tier_2_objective_progress_changed.emit(
			objective_id,
			current_value,
			target_value
		)

		if (
			target_value > 0.0
			and current_value >= target_value
		):
			objective_to_complete = (
				objective_id
			)

			break

	if objective_to_complete != &"":
		complete_tier_2_objective(
			objective_to_complete
		)
		
func complete_tier_2_objective(
	objective_id: StringName
) -> void:
	if tier_2_completed_objectives.has(
		objective_id
	):
		return

	if not tier_2_active_objective_ids.has(
		objective_id
	):
		return

	var objective: Dictionary = (
		get_tier_2_objective_by_id(
			objective_id
		)
	)

	if objective.is_empty():
		return

	var objective_title: String = str(
		objective.get(
			"title",
			"Tier 2 Objective"
		)
	)

	tier_2_completed_objectives[
		objective_id
		] = true

	tier_2_active_objective_ids.erase(
		objective_id
	)

	grant_tier_2_objective_reward(
		objective_id
	)

	print(
		"ObjectiveManager: Tier 2 objective complete: ",
		objective_title
	)

	objective_completed.emit(
		objective_id,
		objective_title
	)

	fill_tier_2_active_objective_slots()

	if (
		tier_2_completed_objectives.size()
		>= TIER_2_OBJECTIVE_ORDER.size()
	):
		finish_tier_2_standard_objectives()

		return

	emit_tier_2_active_objectives()

	call_deferred(
		"evaluate_tier_2_active_objectives"
	)
	
func award_tier_2_money(
	amount: float,
	source: String
) -> void:
	if amount <= 0.0:
		return

	suppress_tier_2_revenue_tracking = true

	GameState.set_revenue(
		GameState.revenue + amount
	)

	suppress_tier_2_revenue_tracking = false

	print(
		"ObjectiveManager: Awarded $%.2f - %s"
		% [
			amount,
			source
		]
	)
	
func award_tier_2_research_points(
	amount: float,
	source: String
) -> void:
	if amount <= 0.0:
		return

	ResearchManager.award_research_points(
		amount,
		source
	)
	
func award_tier_2_active_users(
	amount: int
) -> void:
	if amount <= 0:
		return

	GameState.set_active_users(
		GameState.active_users + amount
	)
	
func grant_tier_2_objective_reward(
	objective_id: StringName
) -> void:
	tier_2_reward_in_progress = true

	match objective_id:
		OBJECTIVE_T2_INDEX_2000_PAGES:
			award_tier_2_money(
				100.0,
				"Index 2,000 Pages"
			)

			award_tier_2_research_points(
				25.0,
				"Tier 2 Objective: Index 2,000 Pages"
			)

		OBJECTIVE_T2_REACH_150_USERS:
			award_tier_2_research_points(
				10.0,
				"Tier 2 Objective: Reach 150 Active Users"
			)

		OBJECTIVE_T2_COMPLETE_3_ACTIVITIES:
			# Repeatable Activity cooldown unlock will
			# be implemented with the third Tier 2 Activity.
			print(
				"ObjectiveManager: "
				+ "Activity repeat unlock earned."
			)

		OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS:
			award_tier_2_money(
				100.0,
				"Purchase 3 Server Upgrade Levels"
			)

		OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS:
			award_tier_2_research_points(
				25.0,
				(
					"Tier 2 Objective: "
					+ "Purchase 2 Research Upgrade Levels"
				)
			)

		OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS:
			award_tier_2_money(
				100.0,
				"Complete 2 Expanded Crawl Jobs"
			)

			award_tier_2_research_points(
				20.0,
				(
					"Tier 2 Objective: "
					+ "Complete 2 Expanded Crawl Jobs"
				)
			)

			award_tier_2_active_users(
				30
			)

		OBJECTIVE_T2_EARN_250_REVENUE:
			award_tier_2_money(
				50.0,
				"Earn $250 Revenue During Tier"
			)

	tier_2_reward_in_progress = false
	
func get_tier_2_objective_reward_text(
	objective_id: StringName
) -> String:
	match objective_id:
		OBJECTIVE_T2_INDEX_2000_PAGES:
			return "$100 + 25 RP"

		OBJECTIVE_T2_REACH_150_USERS:
			return "10 RP"

		OBJECTIVE_T2_COMPLETE_3_ACTIVITIES:
			return "Repeatable Activities Unlock"

		OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS:
			return "$100"

		OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS:
			return "25 RP"

		OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS:
			return "$100 + 20 RP + 30 Active Users"

		OBJECTIVE_T2_EARN_250_REVENUE:
			return "$50"

	return ""
	
	
func finish_tier_2_standard_objectives() -> void:
	if tier_2_standard_objectives_finished:
		return

	tier_2_standard_objectives_finished = true

	tier_2_active_objective_ids.clear()

	print(
		"ObjectiveManager: "
		+ "All 7 Tier 2 standard objectives complete."
	)

	tier_2_active_objectives_changed.emit()

	tier_2_standard_objectives_completed.emit()


func finish_objective_sequence() -> void:
	sequence_completed = true

	begin_tier_2_tracking()

	set_progression_tier(
		PROGRESSION_TIER_2
	)

	all_objectives_completed.emit()
	
func is_tier_2_tracking_active() -> bool:
	return (
		tier_2_tracking_started
		and current_progression_tier
			>= PROGRESSION_TIER_2
	)
	
func get_tier_2_objective_progress(
	objective_id: StringName
) -> float:
	match objective_id:
		OBJECTIVE_T2_INDEX_2000_PAGES:
			return float(
				GameState.indexed_pages
			)

		OBJECTIVE_T2_REACH_150_USERS:
			return float(
				GameState.active_users
			)

		OBJECTIVE_T2_COMPLETE_3_ACTIVITIES:
			return float(
				tier_2_activities_completed
			)

		OBJECTIVE_T2_PURCHASE_3_SERVER_LEVELS:
			return float(
				tier_2_server_upgrade_levels_purchased
			)

		OBJECTIVE_T2_PURCHASE_2_RESEARCH_LEVELS:
			return float(
				tier_2_research_upgrade_levels_purchased
			)

		OBJECTIVE_T2_COMPLETE_2_EXPANDED_CRAWLS:
			return float(
				tier_2_expanded_crawls_completed
			)

		OBJECTIVE_T2_EARN_250_REVENUE:
			return tier_2_revenue_earned

	return 0.0
	
func get_tier_2_objective_target(
	objective_id: StringName
) -> float:
	for objective: Dictionary in TIER_2_OBJECTIVES:
		if (
			objective.get(
				"id",
				&""
			) == objective_id
		):
			return float(
				objective.get(
					"target",
					0.0
				)
			)

	return 0.0
	
func get_tier_2_objective_by_id(
	objective_id: StringName
) -> Dictionary:
	for objective: Dictionary in TIER_2_OBJECTIVES:
		var stored_id: StringName = StringName(
			objective.get(
				"id",
				&""
			)
		)

		if stored_id == objective_id:
			return objective

	return {}
	
func get_tier_2_active_objective_ids() -> Array[StringName]:
	return tier_2_active_objective_ids.duplicate()


func get_tier_2_active_objectives() -> Array[Dictionary]:
	var active_objectives: Array[Dictionary] = []

	for objective_id: StringName in tier_2_active_objective_ids:
		var objective: Dictionary = (
			get_tier_2_objective_by_id(
				objective_id
			)
		)

		if objective.is_empty():
			continue

		active_objectives.append(
			objective
		)

	return active_objectives
	
func is_tier_2_objective_requirement_met(
	objective_id: StringName
) -> bool:
	var target: float = (
		get_tier_2_objective_target(
			objective_id
		)
	)

	if target <= 0.0:
		return false

	return (
		get_tier_2_objective_progress(
			objective_id
		)
		>= target
	)


# -------------------------------------------------------------------
# Indexed pages
# -------------------------------------------------------------------

func _on_indexed_pages_changed(
	_new_total: int
) -> void:
	if is_tier_2_tracking_active():
		evaluate_tier_2_active_objectives()

		return
	var objective_id: StringName = (
		get_current_objective_id()
	)

	if (
		objective_id != OBJECTIVE_INDEX_100_PAGES
		and objective_id != OBJECTIVE_INDEX_500_PAGES
		and objective_id != OBJECTIVE_INDEX_1000_PAGES
		and objective_id != OBJECTIVE_INDEX_2000_PAGES
	):
		return

	evaluate_current_objective()


# -------------------------------------------------------------------
# Active users
# -------------------------------------------------------------------

func _on_active_users_changed(
	_new_total: int
) -> void:
	if is_tier_2_tracking_active():
		evaluate_tier_2_active_objectives()

		return
	var objective_id: StringName = (
		get_current_objective_id()
	)

	if (
		objective_id != OBJECTIVE_REACH_40_USERS
		and objective_id != OBJECTIVE_REACH_100_USERS
	):
		return

	evaluate_current_objective()
	
# -------------------------------------------------------------------
# Crawl jobs
# -------------------------------------------------------------------

func _on_crawl_job_completed() -> void:
	if (
		get_current_objective_id()
		!= OBJECTIVE_COMPLETE_EXPANDED_CRAWL
	):
		return

	if (
		CrawlerManager.selected_job_id
		!= CrawlerManager.CRAWL_JOB_EXPANDED
	):
		return

	current_event_progress = 1

	evaluate_current_objective()
	
# -------------------------------------------------------------------
# Server upgrades
# -------------------------------------------------------------------

func _on_server_upgrade_purchased(
	_upgrade_id: StringName,
	_new_level: int,
	_revenue_spent: float
) -> void:
	if is_tier_2_tracking_active():
		tier_2_server_upgrade_levels_purchased += 1

		print(
			"Tier 2 Server Upgrade Levels: ",
			tier_2_server_upgrade_levels_purchased,
			" / 3"
		)
		
		evaluate_tier_2_active_objectives()

	var objective_id: StringName = (
		get_current_objective_id()
	)

	if objective_id == OBJECTIVE_PURCHASE_SERVER_UPGRADE:
		current_event_progress = 1

		evaluate_current_objective()

		return

	if (
		objective_id
		== OBJECTIVE_PURCHASE_TIER_2_SERVER_UPGRADE
	):
		evaluate_current_objective()


# -------------------------------------------------------------------
# Research upgrades
# -------------------------------------------------------------------

func _on_research_upgrade_purchased(
	_upgrade_id: StringName,
	_new_level: int,
	_research_points_spent: float
) -> void:
	if is_tier_2_tracking_active():
		tier_2_research_upgrade_levels_purchased += 1

		print(
			"Tier 2 Research Upgrade Levels: ",
			tier_2_research_upgrade_levels_purchased,
			" / 2"
		)
		evaluate_tier_2_active_objectives()
		
	var objective_id: StringName = (
		get_current_objective_id()
	)

	if objective_id == OBJECTIVE_COMPLETE_RESEARCH:
		current_event_progress = 1

		evaluate_current_objective()

		return

	if (
		objective_id
		== OBJECTIVE_COMPLETE_TIER_2_RESEARCH
	):
		evaluate_current_objective()
	
# -------------------------------------------------------------------
# Progression Tiers
# -------------------------------------------------------------------
	
func set_progression_tier(
	new_tier: int
) -> void:
	var safe_tier: int = clampi(
		new_tier,
		PROGRESSION_TIER_1,
		MAX_PROGRESSION_TIER
	)

	if safe_tier == current_progression_tier:
		return

	current_progression_tier = safe_tier

	print(
		"ObjectiveManager: Progression Tier changed to ",
		current_progression_tier
	)

	progression_tier_changed.emit(
		current_progression_tier
	)
	
func is_auto_crawl_assist_unlocked() -> bool:
	return is_progression_tier_unlocked(
		PROGRESSION_TIER_2
	)
	
func is_progression_tier_unlocked(
	tier: int
) -> bool:
	if tier < PROGRESSION_TIER_1:
		return false

	if tier > MAX_PROGRESSION_TIER:
		return false

	return current_progression_tier >= tier
	
func get_current_progression_tier() -> int:
	return current_progression_tier


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_objectives() -> void:
	current_objective_index = 0
	current_event_progress = 0
	sequence_completed = false
	
	reset_tier_2_objective_state()

	set_progression_tier(
		PROGRESSION_TIER_1
	)

	activate_current_objective()
	
# -------------------------------------------------------------------
# Save / load support
# -------------------------------------------------------------------

func begin_save_restore() -> void:
	suppress_objective_evaluation = true


func restore_saved_state(
	saved_objective_index: int,
	saved_event_progress: int,
	saved_sequence_completed: bool,
	saved_progression_tier: int,
	saved_tier_2_data: Dictionary = {}
) -> void:
	current_objective_index = clampi(
		saved_objective_index,
		0,
		OBJECTIVES.size()
	)

	current_event_progress = maxi(
		saved_event_progress,
		0
	)

	sequence_completed = (
		saved_sequence_completed
		or current_objective_index
			>= OBJECTIVES.size()
	)

	var restored_tier: int = clampi(
		saved_progression_tier,
		PROGRESSION_TIER_1,
		MAX_PROGRESSION_TIER
	)

	# Older completed saves should migrate into
	# the new Tier 2 objective structure.
	if sequence_completed:
		restored_tier = maxi(
			restored_tier,
			PROGRESSION_TIER_2
		)

	if restored_tier >= PROGRESSION_TIER_2:
		current_objective_index = (
			TIER_1_OBJECTIVE_COUNT
		)

		sequence_completed = false

	restore_tier_2_saved_state(
		saved_tier_2_data,
		restored_tier
	)

	set_progression_tier(
		restored_tier
	)

	suppress_objective_evaluation = false

	if (
		restored_tier >= PROGRESSION_TIER_2
		and tier_2_tracking_started
	):
		tier_2_active_objectives_changed.emit()

		emit_current_objective()

		call_deferred(
			"evaluate_tier_2_active_objectives"
		)

		return

	if sequence_completed:
		all_objectives_completed.emit()

		return

	emit_current_objective()
	emit_current_progress()
	
func get_tier_2_save_data() -> Dictionary:
	var active_ids: Array[String] = []

	for objective_id: StringName in tier_2_active_objective_ids:
		active_ids.append(
			str(objective_id)
		)

	var completed_ids: Array[String] = []

	for objective_id_variant: Variant in (
		tier_2_completed_objectives.keys()
	):
		completed_ids.append(
			str(objective_id_variant)
		)

	return {
		"tracking_started":
			tier_2_tracking_started,

		"activities_completed":
			tier_2_activities_completed,

		"server_upgrade_levels_purchased":
			tier_2_server_upgrade_levels_purchased,

		"research_upgrade_levels_purchased":
			tier_2_research_upgrade_levels_purchased,

		"expanded_crawls_completed":
			tier_2_expanded_crawls_completed,

		"revenue_earned":
			tier_2_revenue_earned,

		"active_objective_ids":
			active_ids,

		"completed_objective_ids":
			completed_ids,

		"next_queue_index":
			tier_2_next_queue_index,

		"standard_objectives_finished":
			tier_2_standard_objectives_finished
	}
	
func reset_tier_2_objective_state() -> void:
	tier_2_tracking_started = false

	tier_2_activities_completed = 0

	tier_2_server_upgrade_levels_purchased = 0

	tier_2_research_upgrade_levels_purchased = 0

	tier_2_expanded_crawls_completed = 0

	tier_2_revenue_earned = 0.0

	tier_2_last_observed_revenue = (
		GameState.revenue
	)

	suppress_tier_2_revenue_tracking = false

	tier_2_active_objective_ids.clear()

	tier_2_completed_objectives.clear()

	tier_2_next_queue_index = 0

	tier_2_standard_objectives_finished = false
	
func restore_tier_2_saved_state(
	data: Dictionary,
	restored_tier: int
) -> void:
	reset_tier_2_objective_state()

	if restored_tier < PROGRESSION_TIER_2:
		return

	tier_2_tracking_started = true

	tier_2_last_observed_revenue = (
		GameState.revenue
	)

	# Older saves will not contain Tier 2 queue data.
	# Start those saves at the beginning of the new
	# Tier 2 objective structure.
	if data.is_empty():
		tier_2_next_queue_index = 0

		fill_tier_2_active_objective_slots()

		return

	tier_2_activities_completed = maxi(
		int(
			data.get(
				"activities_completed",
				0
			)
		),
		0
	)

	tier_2_server_upgrade_levels_purchased = maxi(
		int(
			data.get(
				"server_upgrade_levels_purchased",
				0
			)
		),
		0
	)

	tier_2_research_upgrade_levels_purchased = maxi(
		int(
			data.get(
				"research_upgrade_levels_purchased",
				0
			)
		),
		0
	)

	tier_2_expanded_crawls_completed = maxi(
		int(
			data.get(
				"expanded_crawls_completed",
				0
			)
		),
		0
	)

	tier_2_revenue_earned = maxf(
		float(
			data.get(
				"revenue_earned",
				0.0
			)
		),
		0.0
	)

	tier_2_next_queue_index = clampi(
		int(
			data.get(
				"next_queue_index",
				0
			)
		),
		0,
		TIER_2_OBJECTIVE_ORDER.size()
	)

	var raw_completed_ids: Variant = (
		data.get(
			"completed_objective_ids",
			[]
		)
	)

	if typeof(raw_completed_ids) == TYPE_ARRAY:
		for raw_id: Variant in raw_completed_ids:
			var objective_id: StringName = (
				StringName(
					str(raw_id)
				)
			)

			if not TIER_2_OBJECTIVE_ORDER.has(
				objective_id
			):
				continue

			tier_2_completed_objectives[
				objective_id
			] = true

	var raw_active_ids: Variant = (
		data.get(
			"active_objective_ids",
			[]
		)
	)

	if typeof(raw_active_ids) == TYPE_ARRAY:
		for raw_id: Variant in raw_active_ids:
			var objective_id: StringName = (
				StringName(
					str(raw_id)
				)
			)

			if not TIER_2_OBJECTIVE_ORDER.has(
				objective_id
			):
				continue

			if tier_2_completed_objectives.has(
				objective_id
			):
				continue

			if tier_2_active_objective_ids.has(
				objective_id
			):
				continue

			tier_2_active_objective_ids.append(
				objective_id
			)

	tier_2_standard_objectives_finished = (
		bool(
			data.get(
				"standard_objectives_finished",
				false
			)
		)
		or tier_2_completed_objectives.size()
			>= TIER_2_OBJECTIVE_ORDER.size()
	)

	if tier_2_standard_objectives_finished:
		tier_2_active_objective_ids.clear()

		return

	fill_tier_2_active_objective_slots()
