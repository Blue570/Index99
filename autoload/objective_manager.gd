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
		"description": "Purchase any upgrade from the Servers page.",
		"target": 1
	},
	{
		"id": OBJECTIVE_COMPLETE_RESEARCH,
		"title": "Complete a Research Upgrade",
		"description": "Purchase one level of any research upgrade.",
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
		"title": "Purchase a Tier 2 Server Upgrade",
		"description": "Reach Level 6 on any server upgrade.",
		"target": 1
	},
	{
		"id": OBJECTIVE_COMPLETE_TIER_2_RESEARCH,
		"title": "Complete Tier 2 Research",
		"description": "Reach Level 4 on any research upgrade.",
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

var current_progression_tier: int = (
	PROGRESSION_TIER_1
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
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


# -------------------------------------------------------------------
# Current objective information
# -------------------------------------------------------------------

func get_current_objective() -> Dictionary:
	if sequence_completed:
		return {}

	if (
		current_objective_index < 0
		or current_objective_index >= OBJECTIVES.size()
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

	match objective_id:
		OBJECTIVE_INDEX_100_PAGES:
			return GameState.indexed_pages

		OBJECTIVE_REACH_40_USERS:
			return GameState.active_users

		OBJECTIVE_PURCHASE_SERVER_UPGRADE:
			if ServerManager.has_purchased_any_upgrade():
				return 1

			return 0

		OBJECTIVE_COMPLETE_RESEARCH:
			if ResearchManager.has_completed_any_upgrade():
				return 1

			return 0

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
		ServerManager.cooling_speed_level >= 6
		or ServerManager.crawler_efficiency_level >= 6
		or ServerManager.maximum_safe_load_level >= 6
	)
	
func has_completed_tier_2_research() -> bool:
	return (
		ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
		) >= 4
		or ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_SEARCH_MONETIZATION
		) >= 4
		or ResearchManager.get_upgrade_level(
			ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
		) >= 4
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
		
	if sequence_completed:
		return

	var current_progress: int = (
		get_current_progress()
	)

	var target: int = (
		get_current_objective_target()
	)

	emit_current_progress()

	if current_progress >= target:
		complete_current_objective()


# -------------------------------------------------------------------
# Completing objectives
# -------------------------------------------------------------------

func complete_current_objective() -> void:
	if sequence_completed:
		return

	var objective_id: StringName = (
		get_current_objective_id()
	)

	var objective_title: String = (
		get_current_objective_title()
	)

	if objective_id == &"":
		return

	ResearchManager.award_objective_completion(
		objective_id,
		objective_title
	)

	objective_completed.emit(
		objective_id,
		objective_title
	)
	
	if objective_id == OBJECTIVE_INDEX_500_PAGES:
		set_progression_tier(
			PROGRESSION_TIER_2
		)

	current_objective_index += 1

	activate_current_objective()


func finish_objective_sequence() -> void:
	sequence_completed = true

	all_objectives_completed.emit()


# -------------------------------------------------------------------
# Indexed pages
# -------------------------------------------------------------------

func _on_indexed_pages_changed(
	_new_total: int
) -> void:
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
	var objective_id: StringName = (
		get_current_objective_id()
	)

	if (
		objective_id != OBJECTIVE_PURCHASE_SERVER_UPGRADE
		and objective_id
		!= OBJECTIVE_PURCHASE_TIER_2_SERVER_UPGRADE
	):
		return

	evaluate_current_objective()


# -------------------------------------------------------------------
# Research upgrades
# -------------------------------------------------------------------

func _on_research_upgrade_purchased(
	_upgrade_id: StringName,
	_new_level: int,
	_research_points_spent: float
) -> void:
	var objective_id: StringName = (
		get_current_objective_id()
	)

	if (
		objective_id != OBJECTIVE_COMPLETE_RESEARCH
		and objective_id
		!= OBJECTIVE_COMPLETE_TIER_2_RESEARCH
	):
		return

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
	saved_progression_tier: int
) -> void:
	var migrated_from_old_tier_1_sequence: bool = (
		saved_sequence_completed
		and saved_objective_index
		== TIER_1_OBJECTIVE_COUNT
		and saved_progression_tier
		>= PROGRESSION_TIER_2
	)

	current_objective_index = clampi(
		saved_objective_index,
		0,
		OBJECTIVES.size()
	)

	if migrated_from_old_tier_1_sequence:
		current_objective_index = (
			TIER_1_OBJECTIVE_COUNT
		)

	current_event_progress = maxi(
		saved_event_progress,
		0
	)

	sequence_completed = (
		(
			saved_sequence_completed
			and not migrated_from_old_tier_1_sequence
		)
		or current_objective_index
		>= OBJECTIVES.size()
	)

	var restored_tier: int = clampi(
		saved_progression_tier,
		PROGRESSION_TIER_1,
		MAX_PROGRESSION_TIER
	)

	if (
		current_objective_index
		>= TIER_1_OBJECTIVE_COUNT
	):
		restored_tier = maxi(
			restored_tier,
			PROGRESSION_TIER_2
		)

	set_progression_tier(
		restored_tier
	)

	suppress_objective_evaluation = false

	if sequence_completed:
		all_objectives_completed.emit()
		return

	emit_current_objective()
	emit_current_progress()

	evaluate_current_objective()
