extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal tech_level_changed(
	tech_id: StringName,
	new_level: int
)

signal tech_purchased(
	tech_id: StringName,
	new_level: int,
	money_spent: float,
	research_points_spent: float,
	technical_points_spent: int
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
# Technology Effects
# -------------------------------------------------------------------

func get_total_effect_value(
	effect_id: StringName
) -> float:
	var total_effect: float = 0.0

	for tech_id: StringName in get_all_tech_ids():
		var tech_data: Dictionary = (
			get_tech_data(
				tech_id
			)
		)

		if tech_data.is_empty():
			continue

		var tech_effect_id: StringName = StringName(
			str(
				tech_data.get(
					"effect_id",
					&""
				)
			)
		)

		if tech_effect_id != effect_id:
			continue

		var current_level: int = (
			get_current_level(
				tech_id
			)
		)

		if current_level <= 0:
			continue

		var effect_per_level: float = float(
			tech_data.get(
				"effect_per_level",
				0.0
			)
		)

		total_effect += (
			float(current_level)
			* effect_per_level
		)

	return total_effect
	

# -------------------------------------------------------------------
# Technology Effect Display
# -------------------------------------------------------------------

func get_effect_per_level(
	tech_id: StringName
) -> float:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return maxf(
		float(
			tech_data.get(
				"effect_per_level",
				0.0
			)
		),
		0.0
	)


func get_effect_display_name(
	tech_id: StringName
) -> String:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return str(
		tech_data.get(
			"effect_display_name",
			"Technology Effect"
		)
	)


func get_effect_short_name(
	tech_id: StringName
) -> String:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return str(
		tech_data.get(
			"effect_short_name",
			"Effect"
		)
	)


func get_effect_sign(
	tech_id: StringName
) -> String:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	return str(
		tech_data.get(
			"effect_sign",
			"+"
		)
	)


func get_current_effect_value(
	tech_id: StringName
) -> float:
	return (
		float(
			get_current_level(
				tech_id
			)
		)
		* get_effect_per_level(
			tech_id
		)
	)


func get_next_effect_value(
	tech_id: StringName
) -> float:
	if is_tech_maxed(
		tech_id
	):
		return get_current_effect_value(
			tech_id
		)

	return (
		float(
			get_current_level(
				tech_id
			)
			+ 1
		)
		* get_effect_per_level(
			tech_id
		)
	)


func get_maximum_effect_value(
	tech_id: StringName
) -> float:
	return (
		float(
			get_max_level(
				tech_id
			)
		)
		* get_effect_per_level(
			tech_id
		)
	)


func format_tech_effect_value(
	tech_id: StringName,
	value: float
) -> String:
	if value <= 0.0:
		return "0%"

	var sign_text: String = (
		get_effect_sign(
			tech_id
		)
	)

	if is_equal_approx(
		value,
		float(roundi(value))
	):
		return (
			"%s%d%%"
			% [
				sign_text,
				roundi(value)
			]
		)

	return (
		"%s%.1f%%"
		% [
			sign_text,
			value
		]
	)


func get_compact_effect_text(
	tech_id: StringName
) -> String:
	var effect_name: String = (
		get_effect_short_name(
			tech_id
		)
	)

	var current_text: String = (
		format_tech_effect_value(
			tech_id,
			get_current_effect_value(
				tech_id
			)
		)
	)

	if is_tech_maxed(
		tech_id
	):
		return (
			"%s %s MAX"
			% [
				effect_name,
				current_text
			]
		)

	var next_text: String = (
		format_tech_effect_value(
			tech_id,
			get_next_effect_value(
				tech_id
			)
		)
	)

	return (
		"%s %s -> %s"
		% [
			effect_name,
			current_text,
			next_text
		]
	)


func get_tech_tooltip_text(
	tech_id: StringName
) -> String:
	var tech_data: Dictionary = (
		get_tech_data(
			tech_id
		)
	)

	if tech_data.is_empty():
		return ""

	var tech_name: String = str(
		tech_data.get(
			"name",
			"Unknown Technology"
		)
	)

	var route_name: String = str(
		tech_data.get(
			"route",
			"General"
		)
	)

	var description: String = str(
		tech_data.get(
			"description",
			""
		)
	)

	var effect_name: String = (
		get_effect_display_name(
			tech_id
		)
	)

	var per_level_text: String = (
		format_tech_effect_value(
			tech_id,
			get_effect_per_level(
				tech_id
			)
		)
	)

	var current_text: String = (
		format_tech_effect_value(
			tech_id,
			get_current_effect_value(
				tech_id
			)
		)
	)

	var maximum_text: String = (
		format_tech_effect_value(
			tech_id,
			get_maximum_effect_value(
				tech_id
			)
		)
	)

	var tooltip: String = (
		"%s\n"
		% tech_name
	)

	tooltip += (
		"Route: %s\n\n"
		% route_name
	)

	if not description.is_empty():
		tooltip += (
			description
			+ "\n\n"
		)

	tooltip += (
		"Effect per Level: %s %s\n"
		% [
			per_level_text,
			effect_name
		]
	)

	tooltip += (
		"Current Effect: %s\n"
		% current_text
	)

	if is_tech_maxed(
		tech_id
	):
		tooltip += (
			"Maximum Effect: %s"
			% maximum_text
		)

		return tooltip

	var next_text: String = (
		format_tech_effect_value(
			tech_id,
			get_next_effect_value(
				tech_id
			)
		)
	)

	tooltip += (
		"Next Level: %s\n"
		% next_text
	)

	tooltip += (
		"Maximum Effect: %s"
		% maximum_text
	)

	return tooltip


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
	
func can_afford_tech(
	tech_id: StringName
) -> bool:
	if get_tech_data(tech_id).is_empty():
		return false

	if not is_tech_unlocked(
		tech_id
	):
		return false

	if is_tech_maxed(
		tech_id
	):
		return false

	var money_cost: float = (
		get_next_money_cost(
			tech_id
		)
	)

	var research_cost: float = (
		get_next_research_cost(
			tech_id
		)
	)

	var tech_cost: int = (
		get_next_tech_cost(
			tech_id
		)
	)

	if GameState.revenue < money_cost:
		return false

	if (
		ResearchManager.research_points
		< research_cost
	):
		return false

	if not TechnicalPointsManager.can_afford_technical_points(
		tech_cost
	):
		return false

	return true
	
func purchase_tech(
	tech_id: StringName
) -> bool:
	if not can_afford_tech(
		tech_id
	):
		return false

	var current_level: int = (
		get_current_level(
			tech_id
		)
	)

	var maximum_level: int = (
		get_max_level(
			tech_id
		)
	)

	if current_level >= maximum_level:
		return false

	var money_cost: float = (
		get_next_money_cost(
			tech_id
		)
	)

	var research_cost: float = (
		get_next_research_cost(
			tech_id
		)
	)

	var tech_cost: int = (
		get_next_tech_cost(
			tech_id
		)
	)

	if money_cost > 0.0:
		GameState.set_revenue(
			GameState.revenue
			- money_cost
		)

	if research_cost > 0.0:
		ResearchManager.spend_research_points(
			research_cost
		)

	if tech_cost > 0:
		TechnicalPointsManager.spend_technical_points(
			tech_cost,
			get_tech_name(
				tech_id
			)
		)

	var new_level: int = (
		current_level + 1
	)

	tech_levels[
		tech_id
	] = new_level

	tech_level_changed.emit(
		tech_id,
		new_level
	)

	tech_purchased.emit(
		tech_id,
		new_level,
		money_cost,
		research_cost,
		tech_cost
	)

	BuildManager.add_build_progress(
		1
	)

	print(
		"TechTreeManager: Purchased %s Level %d."
		% [
			get_tech_name(
				tech_id
			),
			new_level
		]
	)

	return true
	
# -------------------------------------------------------------------
# Save / Load
# -------------------------------------------------------------------

func get_save_data() -> Dictionary:
	var saved_levels: Dictionary = {}

	for tech_id: StringName in get_all_tech_ids():
		saved_levels[
			str(tech_id)
		] = get_current_level(
			tech_id
		)

	return {
		"levels": saved_levels
	}


func restore_saved_state(
	data: Dictionary
) -> void:
	var saved_levels: Dictionary = {}

	if (
		data.has("levels")
		and typeof(data["levels"]) == TYPE_DICTIONARY
	):
		saved_levels = data[
			"levels"
		]

	for tech_id: StringName in get_all_tech_ids():
		var saved_level: int = 0

		var tech_key: String = str(
			tech_id
		)

		if saved_levels.has(
			tech_key
		):
			saved_level = int(
				saved_levels[
					tech_key
				]
			)

		var maximum_level: int = (
			get_max_level(
				tech_id
			)
		)

		saved_level = clampi(
			saved_level,
			0,
			maximum_level
		)

		tech_levels[
			tech_id
		] = saved_level

		tech_level_changed.emit(
			tech_id,
			saved_level
		)

	print(
		"TechTreeManager: Restored Tech Tree state."
	)


func reset_tech_tree() -> void:
	for tech_id: StringName in get_all_tech_ids():
		tech_levels[
			tech_id
		] = 0

		tech_level_changed.emit(
			tech_id,
			0
		)

	print(
		"TechTreeManager: Tech Tree reset."
	)
