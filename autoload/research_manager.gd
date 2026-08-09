extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal research_points_changed(
	new_points: float
)

signal research_upgrade_unlocked(
	upgrade_id: StringName
)

signal research_upgrade_level_changed(
	upgrade_id: StringName,
	new_level: int
)

signal research_points_awarded(
	amount: float,
	source: String
)


# -------------------------------------------------------------------
# Upgrade identifiers
# -------------------------------------------------------------------

const UPGRADE_QUERY_OPTIMIZATION: StringName = (
	&"query_optimization"
)

const UPGRADE_CRAWLER_ALGORITHMS: StringName = (
	&"crawler_algorithms"
)

const UPGRADE_DATA_COMPRESSION: StringName = (
	&"data_compression"
)


# -------------------------------------------------------------------
# Upgrade levels
# -------------------------------------------------------------------

const MIN_UPGRADE_LEVEL: int = 0
const MAX_UPGRADE_LEVEL: int = 3


# -------------------------------------------------------------------
# Upgrade names
# -------------------------------------------------------------------

const UPGRADE_NAMES: Dictionary = {
	UPGRADE_QUERY_OPTIMIZATION:
		"Query Optimization",

	UPGRADE_CRAWLER_ALGORITHMS:
		"Crawler Algorithms",

	UPGRADE_DATA_COMPRESSION:
		"Data Compression"
}


# -------------------------------------------------------------------
# Upgrade costs
#
# Array position:
# 0 = Cost to purchase Level 1
# 1 = Cost to purchase Level 2
# 2 = Cost to purchase Level 3
# -------------------------------------------------------------------

const UPGRADE_COSTS: Dictionary = {
	UPGRADE_QUERY_OPTIMIZATION: [
		10.0,
		20.0,
		35.0
	],

	UPGRADE_CRAWLER_ALGORITHMS: [
		15.0,
		30.0,
		50.0
	],

	UPGRADE_DATA_COMPRESSION: [
		25.0,
		45.0,
		70.0
	]
}

# -------------------------------------------------------------------
# Research milestone rewards
# -------------------------------------------------------------------

const INDEXED_PAGE_MILESTONE_INTERVAL: int = 25
const INDEXED_PAGE_MILESTONE_REWARD: float = 1.0

const ACTIVE_USER_MILESTONE_INTERVAL: int = 25
const ACTIVE_USER_MILESTONE_REWARD: float = 2.0

const CRAWL_JOB_COMPLETION_REWARD: float = 3.0

const OBJECTIVE_COMPLETION_REWARD: float = 5.0


# -------------------------------------------------------------------
# Research points
# -------------------------------------------------------------------

var research_points: float = 0.0

var next_indexed_page_milestone: int = (
	INDEXED_PAGE_MILESTONE_INTERVAL
)

var next_active_user_milestone: int = (
	ACTIVE_USER_MILESTONE_INTERVAL
)

var rewarded_objectives: Dictionary = {}


# -------------------------------------------------------------------
# Current upgrade levels
# -------------------------------------------------------------------

var upgrade_levels: Dictionary = {
	UPGRADE_QUERY_OPTIMIZATION: 0,
	UPGRADE_CRAWLER_ALGORITHMS: 0,
	UPGRADE_DATA_COMPRESSION: 0
}


# -------------------------------------------------------------------
# Unlocked research
#
# These values match the temporary Research page.
# -------------------------------------------------------------------

var unlocked_upgrades: Dictionary = {
	UPGRADE_QUERY_OPTIMIZATION: true,
	UPGRADE_CRAWLER_ALGORITHMS: true,
	UPGRADE_DATA_COMPRESSION: false
}


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	initialize_milestone_tracking()

	call_deferred(
		"connect_milestone_signals"
	)

	print(
		"ResearchManager loaded successfully."
	)
	
# -------------------------------------------------------------------
# Milestone setup
# -------------------------------------------------------------------

func initialize_milestone_tracking() -> void:
	next_indexed_page_milestone = (
		get_next_milestone(
			GameState.indexed_pages,
			INDEXED_PAGE_MILESTONE_INTERVAL
		)
	)

	next_active_user_milestone = (
		get_next_milestone(
			GameState.active_users,
			ACTIVE_USER_MILESTONE_INTERVAL
		)
	)
	
func get_next_milestone(
	current_value: int,
	interval: int
) -> int:
	if interval <= 0:
		return 0

	var completed_intervals: int = floori(
		float(current_value)
		/ float(interval)
	)

	return (
		(completed_intervals + 1)
		* interval
	)


# -------------------------------------------------------------------
# Research points
# -------------------------------------------------------------------

func set_research_points(
	new_points: float
) -> void:
	var safe_points: float = maxf(
		new_points,
		0.0
	)

	if is_equal_approx(
		safe_points,
		research_points
	):
		return

	research_points = safe_points

	research_points_changed.emit(
		research_points
	)


func add_research_points(
	amount: float
) -> void:
	if amount <= 0.0:
		return

	set_research_points(
		research_points + amount
	)
	
func award_research_points(
	amount: float,
	source: String
) -> void:
	if amount <= 0.0:
		return

	add_research_points(
		amount
	)

	research_points_awarded.emit(
		amount,
		source
	)


func spend_research_points(
	amount: float
) -> bool:
	if amount <= 0.0:
		return false

	if research_points < amount:
		return false

	set_research_points(
		research_points - amount
	)

	return true
	
# -------------------------------------------------------------------
# Indexed-page milestones
# -------------------------------------------------------------------

func _on_indexed_pages_changed(
	new_total: int
) -> void:
	while (
		new_total
		>= next_indexed_page_milestone
	):
		var milestone_reached: int = (
			next_indexed_page_milestone
		)

		award_research_points(
			INDEXED_PAGE_MILESTONE_REWARD,
			"Indexed %d Pages"
			% milestone_reached
		)

		next_indexed_page_milestone += (
			INDEXED_PAGE_MILESTONE_INTERVAL
		)
		
# -------------------------------------------------------------------
# Active-user milestones
# -------------------------------------------------------------------

func _on_active_users_changed(
	new_total: int
) -> void:
	while (
		new_total
		>= next_active_user_milestone
	):
		var milestone_reached: int = (
			next_active_user_milestone
		)

		award_research_points(
			ACTIVE_USER_MILESTONE_REWARD,
			"Reached %d Active Users"
			% milestone_reached
		)

		next_active_user_milestone += (
			ACTIVE_USER_MILESTONE_INTERVAL
		)
		
# -------------------------------------------------------------------
# Crawl-job milestones
# -------------------------------------------------------------------

func _on_crawl_job_completed() -> void:
	award_research_points(
		CRAWL_JOB_COMPLETION_REWARD,
		"Crawl Job Completed"
	)
	
# -------------------------------------------------------------------
# Objective milestones
# -------------------------------------------------------------------

func award_objective_completion(
	objective_id: StringName,
	objective_name: String
) -> bool:
	if rewarded_objectives.has(
		objective_id
	):
		return false

	rewarded_objectives[
		objective_id
	] = true

	award_research_points(
		OBJECTIVE_COMPLETION_REWARD,
		"Objective Complete: %s"
		% objective_name
	)

	return true


# -------------------------------------------------------------------
# Upgrade information
# -------------------------------------------------------------------

func get_upgrade_name(
	upgrade_id: StringName
) -> String:
	return str(
		UPGRADE_NAMES.get(
			upgrade_id,
			"Unknown Research"
		)
	)


func get_upgrade_level(
	upgrade_id: StringName
) -> int:
	return int(
		upgrade_levels.get(
			upgrade_id,
			0
		)
	)


func get_upgrade_maximum_level() -> int:
	return MAX_UPGRADE_LEVEL


func is_upgrade_unlocked(
	upgrade_id: StringName
) -> bool:
	return bool(
		unlocked_upgrades.get(
			upgrade_id,
			false
		)
	)


func is_upgrade_maxed(
	upgrade_id: StringName
) -> bool:
	return (
		get_upgrade_level(upgrade_id)
		>= MAX_UPGRADE_LEVEL
	)


# -------------------------------------------------------------------
# Upgrade costs
# -------------------------------------------------------------------

func get_upgrade_cost(
	upgrade_id: StringName
) -> float:
	if not is_upgrade_unlocked(upgrade_id):
		return -1.0

	if is_upgrade_maxed(upgrade_id):
		return -1.0

	if not UPGRADE_COSTS.has(upgrade_id):
		return -1.0

	var costs: Array = UPGRADE_COSTS[
		upgrade_id
	]

	var current_level: int = (
		get_upgrade_level(upgrade_id)
	)

	if current_level >= costs.size():
		return -1.0

	return float(
		costs[current_level]
	)


func can_afford_upgrade(
	upgrade_id: StringName
) -> bool:
	var upgrade_cost: float = (
		get_upgrade_cost(upgrade_id)
	)

	if upgrade_cost < 0.0:
		return false

	return (
		research_points
		>= upgrade_cost
	)


# -------------------------------------------------------------------
# Unlock research
# -------------------------------------------------------------------

func unlock_upgrade(
	upgrade_id: StringName
) -> bool:
	if not unlocked_upgrades.has(upgrade_id):
		return false

	if is_upgrade_unlocked(upgrade_id):
		return false

	unlocked_upgrades[upgrade_id] = true

	research_upgrade_unlocked.emit(
		upgrade_id
	)

	return true


# -------------------------------------------------------------------
# Upgrade levels
# -------------------------------------------------------------------

func set_upgrade_level(
	upgrade_id: StringName,
	new_level: int
) -> void:
	if not upgrade_levels.has(upgrade_id):
		return

	var safe_level: int = clampi(
		new_level,
		MIN_UPGRADE_LEVEL,
		MAX_UPGRADE_LEVEL
	)

	var current_level: int = (
		get_upgrade_level(upgrade_id)
	)

	if safe_level == current_level:
		return

	upgrade_levels[upgrade_id] = safe_level

	research_upgrade_level_changed.emit(
		upgrade_id,
		safe_level
	)


func increase_upgrade_level(
	upgrade_id: StringName
) -> bool:
	if not is_upgrade_unlocked(upgrade_id):
		return false

	if is_upgrade_maxed(upgrade_id):
		return false

	var current_level: int = (
		get_upgrade_level(upgrade_id)
	)

	set_upgrade_level(
		upgrade_id,
		current_level + 1
	)

	return true
	
func connect_milestone_signals() -> void:
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

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed
		)
		
		


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_research() -> void:
	set_research_points(0.0)

	set_upgrade_level(
		UPGRADE_QUERY_OPTIMIZATION,
		0
	)

	set_upgrade_level(
		UPGRADE_CRAWLER_ALGORITHMS,
		0
	)

	set_upgrade_level(
		UPGRADE_DATA_COMPRESSION,
		0
	)

	unlocked_upgrades[
		UPGRADE_QUERY_OPTIMIZATION
	] = true

	unlocked_upgrades[
		UPGRADE_CRAWLER_ALGORITHMS
	] = true

	unlocked_upgrades[
		UPGRADE_DATA_COMPRESSION
	] = false
	
	rewarded_objectives.clear()

	initialize_milestone_tracking()
