class_name TechNode
extends Button


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal tech_selected(
	tech_id: StringName
)


# -------------------------------------------------------------------
# Node Settings
# -------------------------------------------------------------------

const NODE_WIDTH: float = 110.0
const NODE_HEIGHT: float = 74.0

const LEVEL_BOX_HEIGHT: float = 6.0


# -------------------------------------------------------------------
# Tech State
# -------------------------------------------------------------------

var tech_id: StringName = &""


# -------------------------------------------------------------------
# Generated UI
# -------------------------------------------------------------------

var name_label: Label
var level_label: Label
var category_label: Label
var cost_label: Label
var effect_label: Label

var level_boxes_row: HBoxContainer


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	custom_minimum_size = Vector2(
		NODE_WIDTH,
		NODE_HEIGHT
	)

	text = ""

	focus_mode = Control.FOCUS_NONE

	mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND
	)

	apply_tech_node_theme()

	build_interface()

	if not pressed.is_connected(
		_on_pressed
	):
		pressed.connect(
			_on_pressed
		)

	refresh_tech_node()


# -------------------------------------------------------------------
# Interface Construction
# -------------------------------------------------------------------

func apply_tech_node_theme() -> void:
	add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)

	add_theme_stylebox_override(
		"focus",
		ThemeManager.create_window_button_hover_style()
	)

	add_theme_stylebox_override(
		"disabled",
		ThemeManager.create_window_button_normal_style()
	)

	add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_PRIMARY
	)

	add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_PRIMARY
	)

	add_theme_color_override(
		"font_disabled_color",
		ThemeManager.TEXT_DISABLED
	)

func build_interface() -> void:
	var content_margin: MarginContainer = (
		MarginContainer.new()
	)

	content_margin.name = "ContentMargin"

	content_margin.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	content_margin.add_theme_constant_override(
		"margin_left",
		4
	)

	content_margin.add_theme_constant_override(
		"margin_right",
		4
	)

	content_margin.add_theme_constant_override(
		"margin_top",
		3
	)

	content_margin.add_theme_constant_override(
		"margin_bottom",
		3
	)

	content_margin.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	add_child(
		content_margin
	)

	var main_layout: VBoxContainer = (
		VBoxContainer.new()
	)

	main_layout.name = "MainLayout"

	main_layout.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	main_layout.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	main_layout.add_theme_constant_override(
		"separation",
		1
	)

	main_layout.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	content_margin.add_child(
		main_layout
	)

	name_label = Label.new()

	name_label.name = "NameLabel"

	name_label.add_theme_font_size_override(
		"font_size",
		10
	)

	name_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	name_label.clip_text = true

	name_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		name_label
	)

	var information_row: HBoxContainer = (
		HBoxContainer.new()
	)

	information_row.name = "InformationRow"

	information_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	information_row.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		information_row
	)

	category_label = Label.new()

	category_label.name = "CategoryLabel"

	category_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	category_label.add_theme_font_size_override(
		"font_size",
		8
	)

	category_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	category_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	information_row.add_child(
		category_label
	)

	level_label = Label.new()

	level_label.name = "LevelLabel"

	level_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	level_label.add_theme_font_size_override(
		"font_size",
		8
	)

	level_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	level_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	information_row.add_child(
		level_label
	)

	effect_label = Label.new()

	effect_label.name = "EffectLabel"

	effect_label.add_theme_font_size_override(
		"font_size",
		8
	)

	effect_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	effect_label.clip_text = true

	effect_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		effect_label
	)

	cost_label = Label.new()

	cost_label.name = "CostLabel"

	cost_label.add_theme_font_size_override(
		"font_size",
		8
	)

	cost_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	cost_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		cost_label
	)

	var spacer: Control = Control.new()

	spacer.name = "Spacer"

	spacer.size_flags_vertical = (
		Control.SIZE_EXPAND_FILL
	)

	spacer.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		spacer
	)

	level_boxes_row = HBoxContainer.new()

	level_boxes_row.name = "LevelBoxesRow"

	level_boxes_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	level_boxes_row.add_theme_constant_override(
		"separation",
		2
	)

	level_boxes_row.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	main_layout.add_child(
		level_boxes_row
	)


# -------------------------------------------------------------------
# Tech Configuration
# -------------------------------------------------------------------

func configure(
	new_tech_id: StringName
) -> void:
	tech_id = new_tech_id

	refresh_tech_node()


func refresh_tech_node() -> void:
	if tech_id == &"":
		return

	var tech_data: Dictionary = (
		TechTreeManager.get_tech_data(
			tech_id
		)
	)

	if tech_data.is_empty():
		return

	name_label.text = str(
		tech_data.get(
			"name",
			"Unknown Tech"
		)
	)

	category_label.text = str(
		tech_data.get(
			"category",
			"General"
		)
	)

	var current_level: int = (
		TechTreeManager.get_current_level(
			tech_id
		)
	)

	var maximum_level: int = (
		TechTreeManager.get_max_level(
			tech_id
		)
	)

	level_label.text = (
		"Lv %d/%d"
		% [
			current_level,
			maximum_level
		]
	)

	effect_label.text = (
		TechTreeManager.get_compact_effect_text(
			tech_id
		)
	)

	tooltip_text = (
		TechTreeManager.get_tech_tooltip_text(
			tech_id
		)
	)

	refresh_cost_display()
	refresh_level_boxes()
	refresh_visual_state()


# -------------------------------------------------------------------
# Cost Display
# -------------------------------------------------------------------

func refresh_cost_display() -> void:
	if TechTreeManager.is_tech_maxed(
		tech_id
	):
		cost_label.text = "MAXIMUM"

		return

	if not TechTreeManager.is_tech_unlocked(
		tech_id
	):
		cost_label.text = "LOCKED"

		return

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

	var cost_parts: Array[String] = []

	if money_cost > 0.0:
		cost_parts.append(
			"$%d"
			% roundi(money_cost)
		)

	if research_cost > 0.0:
		cost_parts.append(
			"%d RP"
			% roundi(research_cost)
		)

	if tech_cost > 0:
		cost_parts.append(
			"%d TP"
			% tech_cost
		)

	if cost_parts.is_empty():
		cost_label.text = "NO COST"

		return

	cost_label.text = (
		" + ".join(
			cost_parts
		)
	)


# -------------------------------------------------------------------
# Level Boxes
# -------------------------------------------------------------------

func refresh_level_boxes() -> void:
	for child: Node in (
		level_boxes_row.get_children()
	):
		level_boxes_row.remove_child(
			child
		)

		child.queue_free()

	var current_level: int = (
		TechTreeManager.get_current_level(
			tech_id
		)
	)

	var maximum_level: int = (
		TechTreeManager.get_max_level(
			tech_id
		)
	)

	var tech_unlocked: bool = (
		TechTreeManager.is_tech_unlocked(
			tech_id
		)
	)

	for level_index: int in range(
		maximum_level
	):
		var level_box: ColorRect = (
			ColorRect.new()
		)

		level_box.custom_minimum_size = Vector2(
			4.0,
			LEVEL_BOX_HEIGHT
		)

		level_box.size_flags_horizontal = (
			Control.SIZE_EXPAND_FILL
		)

		level_box.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)

		if level_index < current_level:
			level_box.color = (
				ThemeManager.STATUS_SUCCESS
			)

		elif (
			tech_unlocked
			and level_index == current_level
			and current_level < maximum_level
		):
			level_box.color = (
				ThemeManager.STATUS_INFORMATION
			)

		else:
			level_box.color = (
				ThemeManager.TEXT_DISABLED
			)

		level_boxes_row.add_child(
			level_box
		)


# -------------------------------------------------------------------
# Visual State
# -------------------------------------------------------------------

func refresh_visual_state() -> void:
	if TechTreeManager.is_tech_maxed(
		tech_id
	):
		disabled = false

		name_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		category_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_SECONDARY
		)

		level_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		cost_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		mouse_default_cursor_shape = (
			Control.CURSOR_ARROW
		)

		return

	if not TechTreeManager.is_tech_unlocked(
		tech_id
	):
		disabled = true

		name_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		category_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		level_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		cost_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		mouse_default_cursor_shape = (
			Control.CURSOR_ARROW
		)

		return

	disabled = false

	name_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	category_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	level_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	cost_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND
	)


# -------------------------------------------------------------------
# Input
# -------------------------------------------------------------------

func _on_pressed() -> void:
	if tech_id == &"":
		return

	if not TechTreeManager.is_tech_unlocked(
		tech_id
	):
		return

	tech_selected.emit(
		tech_id
	)
