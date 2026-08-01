extends Control

@onready var desktop_background: ColorRect = $DesktopBackground

@onready var main_application_window: PanelContainer = (
	$MainApplicationWindow
)

@onready var title_bar: PanelContainer = (
	$MainApplicationWindow/MainLayout/TitleBar
)

@onready var title_bar_layout: HBoxContainer = (
	$MainApplicationWindow/MainLayout/TitleBar/TitleBarLayout
)

@onready var app_icon_frame: PanelContainer = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/AppIconFrame
)

@onready var app_icon_label: Label = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/AppIconFrame/AppIconLabel
)

@onready var title_label: Label = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/TitleLabel
)

@onready var build_label: Label = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/BuildLabel
)

@onready var window_controls: HBoxContainer = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/WindowControls
)

@onready var minimize_button: Button = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/WindowControls/MinimizeButton
)

@onready var maximize_button: Button = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/WindowControls/MaximizeButton
)

@onready var close_button: Button = (
	$MainApplicationWindow/MainLayout/TitleBar
	/TitleBarLayout/WindowControls/CloseButton
)

@onready var resource_bar: PanelContainer = (
	$MainApplicationWindow/MainLayout/ResourceBar
)

@onready var resource_row: HBoxContainer = (
	$MainApplicationWindow/MainLayout/ResourceBar/ResourceRow
)


func _ready() -> void:
	apply_theme_foundation()
	connect_title_bar_buttons()


func apply_theme_foundation() -> void:
	desktop_background.color = ThemeManager.DESKTOP_BACKGROUND

	main_application_window.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_base_panel_style()
	)

	title_bar.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_title_bar_style()
	)

	resource_bar.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_resource_bar_style()
	)

	title_bar_layout.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	resource_row.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	window_controls.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_TINY
	)

	app_icon_frame.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_resource_icon_style(
			ThemeManager.ACCENT_BLUE
		)
	)

	app_icon_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	app_icon_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_TITLE
	)

	build_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE_LIGHT
	)

	build_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	apply_window_button_styles()


func apply_window_button_styles() -> void:
	var standard_buttons: Array[Button] = [
		minimize_button,
		maximize_button
	]

	for button: Button in standard_buttons:
		button.add_theme_stylebox_override(
			"normal",
			ThemeManager.create_window_button_normal_style()
		)

		button.add_theme_stylebox_override(
			"hover",
			ThemeManager.create_window_button_hover_style()
		)

		button.add_theme_stylebox_override(
			"pressed",
			ThemeManager.create_window_button_pressed_style()
		)

		button.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

		button.add_theme_color_override(
			"font_hover_color",
			ThemeManager.TEXT_PRIMARY
		)

		button.add_theme_color_override(
			"font_pressed_color",
			ThemeManager.TEXT_LIGHT
		)

	close_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	close_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style(true)
	)

	close_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style(true)
	)

	close_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	close_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_LIGHT
	)

	close_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)


func connect_title_bar_buttons() -> void:
	minimize_button.pressed.connect(
		_on_minimize_button_pressed
	)

	maximize_button.pressed.connect(
		_on_maximize_button_pressed
	)

	close_button.pressed.connect(
		_on_close_button_pressed
	)


func _on_minimize_button_pressed() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_MINIMIZED
	)


func _on_maximize_button_pressed() -> void:
	var current_mode := DisplayServer.window_get_mode()

	if current_mode == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_WINDOWED
		)
	else:
		DisplayServer.window_set_mode(
			DisplayServer.WINDOW_MODE_MAXIMIZED
		)


func _on_close_button_pressed() -> void:
	get_tree().quit()
