extends PanelContainer
class_name ResourceDisplay

@export_category("Resource Display")

@export var display_name: String = "Resource"
@export var display_value: String = "0"
@export var icon_text: String = "?"
@export var accent_color: Color = Color("#285E9A")
@export var value_color: Color = Color("#285E9A")

@onready var content: HBoxContainer = $Content
@onready var icon_frame: PanelContainer = $Content/IconFrame
@onready var icon_label: Label = $Content/IconFrame/IconLabel
@onready var name_label: Label = $Content/TextColumn/NameLabel
@onready var value_label: Label = $Content/TextColumn/ValueLabel


func _ready() -> void:
	apply_component_theme()
	refresh_display()


func apply_component_theme() -> void:
	add_theme_stylebox_override(
		"panel",
		ThemeManager.create_resource_display_style()
	)

	icon_frame.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_resource_icon_style(accent_color)
	)

	content.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_NORMAL
	)

	icon_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	icon_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	name_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	name_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	value_label.add_theme_color_override(
		"font_color",
		value_color
	)

	value_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SECTION_HEADER
	)


func refresh_display() -> void:
	name_label.text = display_name
	value_label.text = display_value
	icon_label.text = icon_text


func set_display_value(new_value: String) -> void:
	display_value = new_value

	if is_node_ready():
		value_label.text = display_value


func configure(
	new_name: String,
	new_value: String,
	new_icon: String,
	new_accent_color: Color,
	new_value_color: Color
) -> void:
	display_name = new_name
	display_value = new_value
	icon_text = new_icon
	accent_color = new_accent_color
	value_color = new_value_color

	if is_node_ready():
		apply_component_theme()
		refresh_display()
