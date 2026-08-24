extends Button
class_name TabButton

signal tab_selected(tab_id: StringName)

var tutorial_pulse_active: bool = false
var tutorial_pulse_tween: Tween = null

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
	
func set_tutorial_pulse_active(active: bool) -> void:
	if tutorial_pulse_active == active:
		return

	tutorial_pulse_active = active

	if tutorial_pulse_tween != null:
		tutorial_pulse_tween.kill()
		tutorial_pulse_tween = null

	self_modulate = Color(1, 1, 1, 1)

	if tutorial_pulse_active:
		start_tutorial_pulse()


func start_tutorial_pulse() -> void:
	tutorial_pulse_tween = create_tween()
	tutorial_pulse_tween.set_loops()

	tutorial_pulse_tween.tween_property(
		self,
		"self_modulate",
		Color(1.0, 0.92, 0.70, 1.0),
		0.45
	)

	tutorial_pulse_tween.tween_property(
		self,
		"self_modulate",
		Color(1, 1, 1, 1),
		0.45
	)
	
func _exit_tree() -> void:
	if tutorial_pulse_tween != null:
		tutorial_pulse_tween.kill()
