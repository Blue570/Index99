extends Button
class_name TabButton

signal tab_selected(tab_id: StringName)

@export_category("Tab")

@export var tab_id: StringName = &"dashboard"
@export var tab_text: String = "Dashboard"

func _ready() -> void:
	toggle_mode = true
	focus_mode = Control.FOCUS_ALL
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	custom_minimum_size = Vector2(132.0, 38.0)

	text = tab_text
	tooltip_text = "Open %s" % tab_text

	apply_component_theme()

	pressed.connect(_on_pressed)


func apply_component_theme() -> void:
	add_theme_stylebox_override(
		"normal",
		ThemeManager.create_tab_inactive_style()
	)

	add_theme_stylebox_override(
		"hover",
		ThemeManager.create_tab_hover_style()
	)

	add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_tab_active_style()
	)

	add_theme_stylebox_override(
		"hover_pressed",
		ThemeManager.create_tab_active_style()
	)

	add_theme_stylebox_override(
		"focus",
		ThemeManager.create_tab_focus_style()
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
		ThemeManager.ACCENT_BLUE
	)

	add_theme_color_override(
		"font_hover_pressed_color",
		ThemeManager.ACCENT_BLUE
	)

	add_theme_color_override(
		"font_focus_color",
		ThemeManager.TEXT_PRIMARY
	)

	add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)


func set_active(is_active: bool) -> void:
	set_pressed_no_signal(is_active)


func _on_pressed() -> void:
	tab_selected.emit(tab_id)
