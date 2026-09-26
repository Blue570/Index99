extends Control


# -------------------------------------------------------------------
# Tech Node Scene
# -------------------------------------------------------------------

const TECH_NODE_SCENE: PackedScene = preload(
	"res://scenes/tech_tree/TechNode.tscn"
)


# -------------------------------------------------------------------
# Layout Settings
# -------------------------------------------------------------------

const PAGE_MARGIN: int = 8

const GRID_HORIZONTAL_SEPARATION: int = 4
const GRID_VERTICAL_SEPARATION: int = 4

const EMPTY_SLOT_MINIMUM_SIZE: Vector2 = Vector2(
	110.0,
	74.0
)


# -------------------------------------------------------------------
# Generated UI
# -------------------------------------------------------------------

var tech_grid: GridContainer

var tech_count_label: Label
var selection_label: Label

var tech_nodes: Dictionary = {}


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	build_page()

	connect_tech_tree_signals()

	build_tech_grid()

	refresh_page_status()


# -------------------------------------------------------------------
# Page Construction
# -------------------------------------------------------------------

func build_page() -> void:
	var page_background: PanelContainer = (
		PanelContainer.new()
	)

	page_background.name = "PageBackground"

	page_background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	page_background.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_page_background_style()
	)

	add_child(
		page_background
	)

	var page_margin: MarginContainer = (
		MarginContainer.new()
	)

	page_margin.name = "PageMargin"

	page_margin.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	page_margin.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	page_margin.add_theme_constant_override(
		"margin_left",
		PAGE_MARGIN
	)

	page_margin.add_theme_constant_override(
		"margin_right",
		PAGE_MARGIN
	)

	page_margin.add_theme_constant_override(
		"margin_top",
		PAGE_MARGIN
	)

	page_margin.add_theme_constant_override(
		"margin_bottom",
		PAGE_MARGIN
	)

	page_background.add_child(
		page_margin
	)

	var page_layout: VBoxContainer = (
		VBoxContainer.new()
	)

	page_layout.name = "PageLayout"

	page_layout.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	page_layout.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	page_layout.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	page_margin.add_child(
		page_layout
	)

	create_page_header(
		page_layout
	)

	var separator: HSeparator = (
		HSeparator.new()
	)

	page_layout.add_child(
		separator
	)

	create_tech_grid(
		page_layout
	)

	create_footer(
		page_layout
	)


# -------------------------------------------------------------------
# Header
# -------------------------------------------------------------------

func create_page_header(
	parent: VBoxContainer
) -> void:
	var header_row: HBoxContainer = (
		HBoxContainer.new()
	)

	header_row.name = "HeaderRow"

	parent.add_child(
		header_row
	)

	var title_label: Label = Label.new()

	title_label.name = "TitleLabel"

	title_label.text = (
		"TECHNOLOGY TREE"
	)

	title_label.add_theme_font_size_override(
		"font_size",
		16
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	header_row.add_child(
		title_label
	)

	var header_spacer: Control = Control.new()

	header_spacer.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	header_row.add_child(
		header_spacer
	)

	tech_count_label = Label.new()

	tech_count_label.name = "TechCountLabel"

	tech_count_label.text = (
		"0 TECHS / 60 SLOTS"
	)

	tech_count_label.add_theme_font_size_override(
		"font_size",
		10
	)

	tech_count_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	header_row.add_child(
		tech_count_label
	)


# -------------------------------------------------------------------
# Grid
# -------------------------------------------------------------------

func create_tech_grid(
	parent: VBoxContainer
) -> void:
	tech_grid = GridContainer.new()

	tech_grid.name = "TechGrid"

	tech_grid.columns = (
		TechTreeData.GRID_COLUMNS
	)

	tech_grid.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	tech_grid.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	tech_grid.add_theme_constant_override(
		"h_separation",
		GRID_HORIZONTAL_SEPARATION
	)

	tech_grid.add_theme_constant_override(
		"v_separation",
		GRID_VERTICAL_SEPARATION
	)

	parent.add_child(
		tech_grid
	)


func build_tech_grid() -> void:
	clear_tech_grid()

	var tech_positions: Dictionary = (
		build_tech_position_lookup()
	)

	for row_index: int in range(
		TechTreeData.GRID_ROWS
	):
		for column_index: int in range(
			TechTreeData.GRID_COLUMNS
		):
			var grid_position: Vector2i = (
				Vector2i(
					column_index,
					row_index
				)
			)

			if tech_positions.has(
				grid_position
			):
				var tech_id: StringName = (
					StringName(
						str(
							tech_positions[
								grid_position
							]
						)
					)
				)

				create_tech_node(
					tech_id
				)

			else:
				create_empty_slot()


func build_tech_position_lookup() -> Dictionary:
	var position_lookup: Dictionary = {}

	for tech_id: StringName in (
		TechTreeManager.get_all_tech_ids()
	):
		var grid_position: Vector2i = (
			TechTreeManager.get_grid_position(
				tech_id
			)
		)

		if not TechTreeManager.is_grid_position_valid(
			grid_position
		):
			continue

		position_lookup[
			grid_position
		] = tech_id

	return position_lookup


func create_tech_node(
	tech_id: StringName
) -> void:
	var tech_node: TechNode = (
		TECH_NODE_SCENE.instantiate()
		as TechNode
	)

	if tech_node == null:
		push_error(
			"TechTreePage: Failed to create TechNode."
		)

		return

	tech_node.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	tech_node.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	tech_grid.add_child(
		tech_node
	)

	tech_node.configure(
		tech_id
	)

	if not tech_node.tech_selected.is_connected(
		_on_tech_selected
	):
		tech_node.tech_selected.connect(
			_on_tech_selected
		)

	tech_nodes[
		tech_id
	] = tech_node


func create_empty_slot() -> void:
	var empty_slot: Control = Control.new()

	empty_slot.custom_minimum_size = (
		EMPTY_SLOT_MINIMUM_SIZE
	)

	empty_slot.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	empty_slot.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	empty_slot.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	tech_grid.add_child(
		empty_slot
	)


func clear_tech_grid() -> void:
	tech_nodes.clear()

	for child: Node in (
		tech_grid.get_children()
	):
		tech_grid.remove_child(
			child
		)

		child.queue_free()


# -------------------------------------------------------------------
# Footer
# -------------------------------------------------------------------

func create_footer(
	parent: VBoxContainer
) -> void:
	var separator: HSeparator = (
		HSeparator.new()
	)

	parent.add_child(
		separator
	)

	selection_label = Label.new()

	selection_label.name = "SelectionLabel"

	selection_label.text = (
		"Select a technology for details."
	)

	selection_label.add_theme_font_size_override(
		"font_size",
		10
	)

	selection_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	parent.add_child(
		selection_label
	)


# -------------------------------------------------------------------
# Signal Connections
# -------------------------------------------------------------------

func connect_tech_tree_signals() -> void:
	if not TechTreeManager.tech_level_changed.is_connected(
		_on_tech_level_changed
	):
		TechTreeManager.tech_level_changed.connect(
			_on_tech_level_changed
		)

	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)


# -------------------------------------------------------------------
# Refresh
# -------------------------------------------------------------------

func refresh_all_tech_nodes() -> void:
	for tech_id_variant: Variant in (
		tech_nodes.keys()
	):
		var tech_id: StringName = (
			StringName(
				str(tech_id_variant)
			)
		)

		var tech_node: TechNode = (
			tech_nodes[
				tech_id
			] as TechNode
		)

		if tech_node == null:
			continue

		tech_node.refresh_tech_node()


func refresh_page_status() -> void:
	var tech_count: int = (
		TechTreeManager
			.get_all_tech_ids()
			.size()
	)

	var total_slots: int = (
		TechTreeData.GRID_COLUMNS
		* TechTreeData.GRID_ROWS
	)

	tech_count_label.text = (
		"%d TECHS / %d SLOTS"
		% [
			tech_count,
			total_slots
		]
	)


# -------------------------------------------------------------------
# Tech Callbacks
# -------------------------------------------------------------------

func _on_tech_selected(
	tech_id: StringName
) -> void:
	var tech_data: Dictionary = (
		TechTreeManager.get_tech_data(
			tech_id
		)
	)

	if tech_data.is_empty():
		return

	var tech_name: String = str(
		tech_data.get(
			"name",
			"Unknown Technology"
		)
	)

	if TechTreeManager.is_tech_maxed(
		tech_id
	):
		selection_label.text = (
			"%s — Maximum level reached."
			% tech_name
		)

		return

	if not TechTreeManager.can_afford_tech(
		tech_id
	):
		var money_cost: float = (
			TechTreeManager.get_next_money_cost(
				tech_id
			)
		)

		var research_cost: float = (
			TechTreeManager.get_next_research_cost(
				tech_id
			)
		)

		var tech_cost: int = (
			TechTreeManager.get_next_tech_cost(
				tech_id
			)
		)

		selection_label.text = (
			"%s — Requires $%d + %d RP + %d TP."
			% [
				tech_name,
				roundi(money_cost),
				roundi(research_cost),
				tech_cost
			]
		)

		return

	var purchase_successful: bool = (
		TechTreeManager.purchase_tech(
			tech_id
		)
	)

	if not purchase_successful:
		selection_label.text = (
			"%s — Purchase failed."
			% tech_name
		)

		return

	var new_level: int = (
		TechTreeManager.get_current_level(
			tech_id
		)
	)

	var maximum_level: int = (
		TechTreeManager.get_max_level(
			tech_id
		)
	)

	selection_label.text = (
		"%s upgraded — Level %d/%d."
		% [
			tech_name,
			new_level,
			maximum_level
		]
	)


func _on_tech_level_changed(
	_tech_id: StringName,
	_new_level: int
) -> void:
	refresh_all_tech_nodes()


func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	refresh_all_tech_nodes()
