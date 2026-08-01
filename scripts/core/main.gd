extends Control

@onready var desktop_background: ColorRect = $DesktopBackground

@onready var main_application_window: PanelContainer = (
	$MainApplicationWindow
)

@onready var title_bar: PanelContainer = (
	$MainApplicationWindow/MainLayout/TitleBar
)

@onready var title_label: Label = (
	$MainApplicationWindow/MainLayout/TitleBar/TitleLabel
)


func _ready() -> void:
	apply_theme_foundation()


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

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_TITLE
	)
