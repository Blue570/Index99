extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal cooling_speed_level_changed(
	new_level: int
)

signal crawler_efficiency_level_changed(
	new_level: int
)

signal maximum_safe_load_level_changed(
	new_level: int
)


# -------------------------------------------------------------------
# Upgrade limits
# -------------------------------------------------------------------

const MIN_UPGRADE_LEVEL: int = 0
const TIER_1_MAX_UPGRADE_LEVEL: int = 5
const MAX_UPGRADE_LEVEL: int = 10


# -------------------------------------------------------------------
# Upgrade identifiers
# -------------------------------------------------------------------

const UPGRADE_COOLING_SPEED: StringName = &"cooling_speed"
const UPGRADE_CRAWLER_EFFICIENCY: StringName = &"crawler_efficiency"
const UPGRADE_MAXIMUM_SAFE_LOAD: StringName = &"maximum_safe_load"


# -------------------------------------------------------------------
# Upgrade costs
# -------------------------------------------------------------------

const COOLING_SPEED_COSTS: Array[float] = [
	100.0,
	225.0,
	400.0,
	650.0,
	1000.0,
	1500.0,
	2200.0,
	3100.0,
	4300.0,
	5800.0
]

const CRAWLER_EFFICIENCY_COSTS: Array[float] = [
	125.0,
	275.0,
	500.0,
	800.0,
	1200.0,
	1800.0,
	2600.0,
	3600.0,
	4900.0,
	6500.0
]

const MAXIMUM_SAFE_LOAD_COSTS: Array[float] = [
	150.0,
	325.0,
	600.0,
	950.0,
	1400.0,
	2100.0,
	3000.0,
	4200.0,
	5600.0,
	7400.0
]


# -------------------------------------------------------------------
# Upgrade effects
# -------------------------------------------------------------------

const COOLING_SPEED_BONUS_PER_LEVEL: float = 1.0
const CRAWLER_EFFICIENCY_BONUS_PER_LEVEL: float = 0.2
const MAXIMUM_SAFE_LOAD_BONUS_PER_LEVEL: float = 5.0


# -------------------------------------------------------------------
# Current upgrade levels
# -------------------------------------------------------------------

var cooling_speed_level: int = 0
var crawler_efficiency_level: int = 0
var maximum_safe_load_level: int = 0


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	print("ServerManager loaded successfully.")


# -------------------------------------------------------------------
# Increase upgrade levels
# -------------------------------------------------------------------

func increase_cooling_speed_level() -> bool:
	if cooling_speed_level >= MAX_UPGRADE_LEVEL:
		return false

	set_cooling_speed_level(
		cooling_speed_level + 1
	)

	return true


func increase_crawler_efficiency_level() -> bool:
	if crawler_efficiency_level >= MAX_UPGRADE_LEVEL:
		return false

	set_crawler_efficiency_level(
		crawler_efficiency_level + 1
	)

	return true


func increase_maximum_safe_load_level() -> bool:
	if maximum_safe_load_level >= MAX_UPGRADE_LEVEL:
		return false

	set_maximum_safe_load_level(
		maximum_safe_load_level + 1
	)

	return true
	
	
signal server_upgrade_purchased(
	upgrade_id: StringName,
	new_level: int,
	revenue_spent: float
)


# -------------------------------------------------------------------
# Set upgrade levels
# -------------------------------------------------------------------

func set_cooling_speed_level(
	new_level: int
) -> void:
	var safe_level: int = clampi(
		new_level,
		MIN_UPGRADE_LEVEL,
		MAX_UPGRADE_LEVEL
	)

	if safe_level == cooling_speed_level:
		return

	cooling_speed_level = safe_level

	cooling_speed_level_changed.emit(
		cooling_speed_level
	)


func set_crawler_efficiency_level(
	new_level: int
) -> void:
	var safe_level: int = clampi(
		new_level,
		MIN_UPGRADE_LEVEL,
		MAX_UPGRADE_LEVEL
	)

	if safe_level == crawler_efficiency_level:
		return

	crawler_efficiency_level = safe_level

	crawler_efficiency_level_changed.emit(
		crawler_efficiency_level
	)


func set_maximum_safe_load_level(
	new_level: int
) -> void:
	var safe_level: int = clampi(
		new_level,
		MIN_UPGRADE_LEVEL,
		MAX_UPGRADE_LEVEL
	)

	if safe_level == maximum_safe_load_level:
		return

	maximum_safe_load_level = safe_level

	maximum_safe_load_level_changed.emit(
		maximum_safe_load_level
	)


# -------------------------------------------------------------------
# Maximum-level checks
# -------------------------------------------------------------------

func is_cooling_speed_maxed() -> bool:
	return (
		cooling_speed_level
		>= MAX_UPGRADE_LEVEL
	)


func is_crawler_efficiency_maxed() -> bool:
	return (
		crawler_efficiency_level
		>= MAX_UPGRADE_LEVEL
	)


func is_maximum_safe_load_maxed() -> bool:
	return (
		maximum_safe_load_level
		>= MAX_UPGRADE_LEVEL
	)
	
# -------------------------------------------------------------------
# Current upgrade effects
# -------------------------------------------------------------------

func get_cooling_speed_bonus() -> float:
	return (
		cooling_speed_level
		* COOLING_SPEED_BONUS_PER_LEVEL
	)


func get_crawler_efficiency_reduction() -> float:
	return (
		crawler_efficiency_level
		* CRAWLER_EFFICIENCY_BONUS_PER_LEVEL
	)


func get_maximum_safe_load_bonus() -> float:
	return (
		maximum_safe_load_level
		* MAXIMUM_SAFE_LOAD_BONUS_PER_LEVEL
	)


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_upgrade_levels() -> void:
	set_cooling_speed_level(0)
	set_crawler_efficiency_level(0)
	set_maximum_safe_load_level(0)
	
# -------------------------------------------------------------------
# Upgrade costs
# -------------------------------------------------------------------

func get_cooling_speed_cost() -> float:
	if is_cooling_speed_maxed():
		return -1.0

	return COOLING_SPEED_COSTS[
		cooling_speed_level
	]


func get_crawler_efficiency_cost() -> float:
	if is_crawler_efficiency_maxed():
		return -1.0

	return CRAWLER_EFFICIENCY_COSTS[
		crawler_efficiency_level
	]


func get_maximum_safe_load_cost() -> float:
	if is_maximum_safe_load_maxed():
		return -1.0

	return MAXIMUM_SAFE_LOAD_COSTS[
		maximum_safe_load_level
	]
	
func has_purchased_any_upgrade() -> bool:
	return (
		cooling_speed_level > 0
		or crawler_efficiency_level > 0
		or maximum_safe_load_level > 0
	)
	
# -------------------------------------------------------------------
# Affordability
# -------------------------------------------------------------------

func can_afford_upgrade(
	upgrade_cost: float
) -> bool:
	if upgrade_cost < 0.0:
		return false

	return (
		GameState.revenue
		>= upgrade_cost
	)


func spend_revenue(
	amount: float
) -> bool:
	if amount <= 0.0:
		return false

	if GameState.revenue < amount:
		return false

	GameState.set_revenue(
		GameState.revenue - amount
	)

	return true
	
# -------------------------------------------------------------------
# Upgrade purchases
# -------------------------------------------------------------------

func purchase_cooling_speed() -> bool:
	
	if not ObjectiveManager.is_server_purchasing_unlocked():
		return false
	
	if cooling_speed_level >= MAX_UPGRADE_LEVEL:
		return false
		
	var next_level: int = (
		cooling_speed_level + 1
	)

	if not is_upgrade_level_unlocked(
		next_level
	):
		return false

	var upgrade_cost: float = (
		get_cooling_speed_cost()
	)

	if not spend_revenue(upgrade_cost):
		return false

	if not increase_cooling_speed_level():
		GameState.set_revenue(
			GameState.revenue + upgrade_cost
		)

		return false

	server_upgrade_purchased.emit(
		UPGRADE_COOLING_SPEED,
		cooling_speed_level,
		upgrade_cost
	)

	return true


func purchase_crawler_efficiency() -> bool:
	
	if not ObjectiveManager.is_server_purchasing_unlocked():
		return false
	
	if crawler_efficiency_level >= MAX_UPGRADE_LEVEL:
		return false

	var next_level: int = (
		crawler_efficiency_level + 1
	)

	if not is_upgrade_level_unlocked(
		next_level
	):
		return false

	var upgrade_cost: float = (
		get_crawler_efficiency_cost()
	)

	if not spend_revenue(upgrade_cost):
		return false

	if not increase_crawler_efficiency_level():
		GameState.set_revenue(
			GameState.revenue + upgrade_cost
		)

		return false

	server_upgrade_purchased.emit(
		UPGRADE_CRAWLER_EFFICIENCY,
		crawler_efficiency_level,
		upgrade_cost
	)

	return true


func purchase_maximum_safe_load() -> bool:
	
	if not ObjectiveManager.is_server_purchasing_unlocked():
		return false
	
	if maximum_safe_load_level >= MAX_UPGRADE_LEVEL:
		return false

	var next_level: int = (
		maximum_safe_load_level + 1
	)

	if not is_upgrade_level_unlocked(
		next_level
	):
		return false

	var upgrade_cost: float = (
		get_maximum_safe_load_cost()
	)

	if not spend_revenue(upgrade_cost):
		return false

	if not increase_maximum_safe_load_level():
		GameState.set_revenue(
			GameState.revenue + upgrade_cost
		)

		return false

	server_upgrade_purchased.emit(
		UPGRADE_MAXIMUM_SAFE_LOAD,
		maximum_safe_load_level,
		upgrade_cost
	)

	return true
	
func is_upgrade_level_unlocked(
	level: int
) -> bool:
	if level <= 0:
		return false

	if level > MAX_UPGRADE_LEVEL:
		return false

	if level <= TIER_1_MAX_UPGRADE_LEVEL:
		return true

	return ObjectiveManager.is_progression_tier_unlocked(
		ObjectiveManager.PROGRESSION_TIER_2
	)
	
func is_next_upgrade_level_unlocked(
	current_level: int
) -> bool:
	var next_level: int = (
		current_level + 1
	)

	return is_upgrade_level_unlocked(
		next_level
	)
