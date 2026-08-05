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
const MAX_UPGRADE_LEVEL: int = 5


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
# Reset
# -------------------------------------------------------------------

func reset_upgrade_levels() -> void:
	set_cooling_speed_level(0)
	set_crawler_efficiency_level(0)
	set_maximum_safe_load_level(0)
