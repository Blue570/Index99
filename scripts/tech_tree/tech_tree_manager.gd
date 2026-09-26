extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal tech_level_changed(
	tech_id: StringName,
	new_level: int
)


# -------------------------------------------------------------------
# Runtime State
# -------------------------------------------------------------------

var tech_levels: Dictionary = {}


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	initialize_tech_tree()


func initialize_tech_tree() -> void:
	tech_levels.clear()

	for tech_id_variant: Variant in (
		TechTreeData.TECH_NODES.keys()
	):
		var tech_id: StringName = (
			tech_id_variant as StringName
		)

		tech_levels[tech_id] = 0

	validate_tech_tree()

	print(
		(
			"TechTreeManager: Loaded %d tech definitions "
			+ "for %dx%d grid."
		)
		% [
			tech_levels.size(),
			TechTreeData.GRID_COLUMNS,
			TechTreeData.GRID_ROWS
		]
	)


# -------------------------------------------------------------------
# Validation
# -------------------------------------------------------------------

func validate_tech_tree() -> void:
	var occupied_positions: Dictionary = {}

	for tech_id: StringName in get_all_tech_ids():
		var tech_data: Dictionary = (
			get_tech_data(
				tech_id
			)
		)

		if tech_data.is_empty():
			push_warning(
				"TechTreeManager: Missing data for %s."
				% str(tech_id)
			)

			continue

		var grid_position: Vector2i = (
			tech_data.get(
				"grid_position",
				Vector2i(-1, -1)
			)
		)

		if not is_grid_position_valid(
			grid_position
		):
			push_warning(
				"TechTreeManager: %s has invalid "
				+ "grid position %s."
				% [
					str(tech_id),
					str(grid_position)
				]
			)

			continue

		if occupied_positions.has(
			grid_position
		):
			push_warning(
				"TechTreeManager: Grid position %s "
				+ "is used by both %s and %s."
				% [
					str(grid_position),
					str(
						occupied_positions[
							grid_position
						]
					),
					str(tech_id)
				]
			)

			continue

		occupied_positions[
			grid_position
		] = tech_id


func is_grid_position_valid(
	grid_position: Vector2i
) -> bool:
	return (
		grid_position.x >= 0
		and grid_position.x
			< TechTreeData.GRID_COLUMNS
		and grid_position.y >= 0
		and grid_position.y
			< TechTreeData.GRID_ROWS
	)


# -------------------------------------------------------------------
# Tech Information
# -------------------------------------------------------------------

func get_all_tech_ids() -> Array[StringName]:
	var tech_ids: Array[StringName] = []

	for tech_id_variant: Variant in (
		TechTreeData.TECH_NODES.keys()
	):
		tech_ids.append(
			tech_id_variant as StringName
		)

	return tech_ids


func get_tech_data(
	tech_id: StringName
) -> Dictionary:
	if not TechTreeData.TECH_NODES.has(
		tech_id
	):
		return {}

	var tech_data: Dictionary = (
		TechTreeData.TECH_NODES[
			tech_id
		]
	)

	return tech_data


func get_tech_name(
	tech_id: StringName
) -> String:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return str(
		tech_data.get(
			"name",
			"Unknown Technology"
		)
	)


func get_grid_position(
	tech_id: StringName
) -> Vector2i:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return tech_data.get(
		"grid_position",
		Vector2i(-1, -1)
	)
	
func get_required_tier(
	tech_id: StringName
) -> int:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return maxi(
		int(
			tech_data.get(
				"required_tier",
				1
			)
		),
		1
	)


func get_prerequisites(
	tech_id: StringName
) -> Array[StringName]:
	var prerequisites: Array[StringName] = []

	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	var raw_prerequisites: Variant = (
		tech_data.get(
			"prerequisites",
			[]
		)
	)

	if typeof(raw_prerequisites) != TYPE_ARRAY:
		return prerequisites

	for raw_id: Variant in raw_prerequisites:
		prerequisites.append(
			StringName(
				str(raw_id)
			)
		)

	return prerequisites


func are_prerequisites_met(
	tech_id: StringName
) -> bool:
	for prerequisite_id: StringName in (
		get_prerequisites(
			tech_id
		)
	):
		if (
			get_current_level(
				prerequisite_id
			)
			<= 0
		):
			return false

	return true


func is_tech_unlocked(
	tech_id: StringName
) -> bool:
	if get_tech_data(tech_id).is_empty():
		return false

	if not ObjectiveManager.is_progression_tier_unlocked(
		get_required_tier(
			tech_id
		)
	):
		return false

	return are_prerequisites_met(
		tech_id
	)


# -------------------------------------------------------------------
# Tech Levels
# -------------------------------------------------------------------

func get_current_level(
	tech_id: StringName
) -> int:
	return int(
		tech_levels.get(
			tech_id,
			0
		)
	)


func get_max_level(
	tech_id: StringName
) -> int:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return maxi(
		int(
			tech_data.get(
				"max_level",
				1
			)
		),
		1
	)


func is_tech_maxed(
	tech_id: StringName
) -> bool:
	return (
		get_current_level(
			tech_id
		)
		>= get_max_level(
			tech_id
		)
	)


# -------------------------------------------------------------------
# Costs
# -------------------------------------------------------------------

func get_next_money_cost(
	tech_id: StringName
) -> float:
	return get_scaled_cost(
		tech_id,
		"base_money_cost",
		"money_cost_growth"
	)


func get_next_research_cost(
	tech_id: StringName
) -> float:
	return get_scaled_cost(
		tech_id,
		"base_research_cost",
		"research_cost_growth"
	)


func get_next_tech_cost(
	tech_id: StringName
) -> int:
	return roundi(
		get_scaled_cost(
			tech_id,
			"base_tech_cost",
			"tech_cost_growth"
		)
	)


func get_scaled_cost(
	tech_id: StringName,
	base_cost_key: String,
	growth_key: String
) -> float:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	if tech_data.is_empty():
		return 0.0

	var base_cost: float = float(
		tech_data.get(
			base_cost_key,
			0.0
		)
	)

	if base_cost <= 0.0:
		return 0.0

	var growth: float = maxf(
		float(
			tech_data.get(
				growth_key,
				1.0
			)
		),
		1.0
	)

	var current_level: int = (
		get_current_level(
			tech_id
		)
	)

	return (
		base_cost
		* pow(
			growth,
			current_level
		)
	)
