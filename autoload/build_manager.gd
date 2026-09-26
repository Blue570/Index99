extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal build_number_changed(
	major: int,
	minor: int,
	patch: int
)


# -------------------------------------------------------------------
# Build Settings
# -------------------------------------------------------------------

const STARTING_MAJOR: int = 0
const STARTING_MINOR: int = 0
const STARTING_PATCH: int = 1


# -------------------------------------------------------------------
# Build State
# -------------------------------------------------------------------

var build_major: int = STARTING_MAJOR
var build_minor: int = STARTING_MINOR
var build_patch: int = STARTING_PATCH


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_build_signals()

	sync_build_to_current_tier()

	emit_build_number_changed()


# -------------------------------------------------------------------
# Signal Connections
# -------------------------------------------------------------------

func connect_build_signals() -> void:
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

	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)
		

# -------------------------------------------------------------------
# Upgrade Progress
# -------------------------------------------------------------------

func _on_server_upgrade_purchased(
	_upgrade_id: StringName,
	_new_level: int,
	_revenue_spent: float
) -> void:
	add_build_progress(
		1
	)


func _on_research_upgrade_purchased(
	_upgrade_id: StringName,
	_new_level: int,
	_research_points_spent: float
) -> void:
	add_build_progress(
		1
	)


func add_build_progress(
	amount: int
) -> void:
	if amount <= 0:
		return

	build_patch += amount

	emit_build_number_changed()
	
	
# -------------------------------------------------------------------
# Tier Progression
# -------------------------------------------------------------------

func _on_progression_tier_changed(
	new_tier: int
) -> void:
	apply_progression_tier(
		new_tier
	)


func apply_progression_tier(
	tier: int
) -> void:
	var new_minor: int = maxi(
		tier - 1,
		0
	)

	if new_minor == build_minor:
		return

	build_minor = new_minor

	# Entering a new Tier represents a major internal
	# software milestone, so patch progress starts over.
	build_patch = 0

	emit_build_number_changed()


func sync_build_to_current_tier() -> void:
	var current_tier: int = (
		ObjectiveManager.get_current_progression_tier()
	)

	var expected_minor: int = maxi(
		current_tier - 1,
		0
	)

	if expected_minor != build_minor:
		build_minor = expected_minor
		
		
# -------------------------------------------------------------------
# Build Information
# -------------------------------------------------------------------

func get_build_major() -> int:
	return build_major


func get_build_minor() -> int:
	return build_minor


func get_build_patch() -> int:
	return build_patch


func get_build_number_text() -> String:
	return "%d.%d.%d" % [
		build_major,
		build_minor,
		build_patch
	]


func emit_build_number_changed() -> void:
	build_number_changed.emit(
		build_major,
		build_minor,
		build_patch
	)


# -------------------------------------------------------------------
# Save / Load
# -------------------------------------------------------------------

func get_save_data() -> Dictionary:
	return {
		"major": build_major,
		"minor": build_minor,
		"patch": build_patch
	}


func restore_saved_state(
	saved_major: int,
	saved_minor: int,
	saved_patch: int
) -> void:
	build_major = maxi(
		saved_major,
		0
	)

	build_minor = maxi(
		saved_minor,
		0
	)

	build_patch = maxi(
		saved_patch,
		0
	)

	emit_build_number_changed()


func reset_build_state() -> void:
	build_major = STARTING_MAJOR
	build_minor = STARTING_MINOR
	build_patch = STARTING_PATCH

	emit_build_number_changed()
