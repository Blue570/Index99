extends PanelContainer
class_name SectionPanel

@export_category("Section Panel")

@export var section_title: String = "Section"
@export var status_text: String = ""
@export var show_status: bool = false
@export var status_color: Color = Color("#285E9A")
@export var minimum_panel_height: float = 120.0

@onready var panel_layout: VBoxContainer = $PanelLayout

@onready var section_header: PanelContainer = (
	$PanelLayout/SectionHeader
)

@onready var header_row: HBoxContainer = (
	$PanelLayout/SectionHeader/HeaderRow
)

@onready var title_label: Label = (
	$PanelLayout/SectionHeader/HeaderRow/TitleLabel
)

@onready var status_badge: PanelContainer = (
	$PanelLayout/SectionHeader/HeaderRow/StatusBadge
)

@onready var status_label: Label = (
	$PanelLayout/SectionHeader/HeaderRow
	/StatusBadge/StatusLabel
)

@onready var content_panel: PanelContainer = (
	$PanelLayout/ContentPanel
)

@onready var content_margin: MarginContainer = (
	$PanelLayout/ContentPanel/ContentMargin
)

@onready var content_container: VBoxContainer = (
	$PanelLayout/ContentPanel/ContentMargin/ContentContainer
)


func _ready() -> void:
	custom_minimum_size.y = max(
		custom_minimum_size.y,
		minimum_panel_height
	)

	apply_component_theme()
	refresh_display()
	print("SectionPanel theme applied: ", section_title)


func apply_component_theme() -> void:
	add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_panel_style()
	)

	section_header.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_header_style()
	)

	content_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_content_style()
	)

	status_badge.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_status_badge_style(
			status_color
		)
	)

	panel_layout.add_theme_constant_override(
		"separation",
		0
	)

	header_row.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	content_margin.add_theme_constant_override(
		"margin_left",
		ThemeManager.SPACING_NORMAL
	)

	content_margin.add_theme_constant_override(
		"margin_top",
		ThemeManager.SPACING_NORMAL
	)

	content_margin.add_theme_constant_override(
		"margin_right",
		ThemeManager.SPACING_NORMAL
	)

	content_margin.add_theme_constant_override(
		"margin_bottom",
		ThemeManager.SPACING_NORMAL
	)

	content_container.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	status_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)


func refresh_display() -> void:
	title_label.text = section_title
	status_label.text = status_text

	status_badge.visible = (
		show_status
		and not status_text.strip_edges().is_empty()
	)


func set_section_title(new_title: String) -> void:
	section_title = new_title

	if is_node_ready():
		title_label.text = section_title


func set_status(
	new_text: String,
	new_color: Color
) -> void:
	status_text = new_text
	status_color = new_color

	if not is_node_ready():
		return

	status_label.text = status_text
	status_badge.visible = not status_text.strip_edges().is_empty()

	status_badge.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_status_badge_style(
			status_color
		)
	)


func hide_status() -> void:
	show_status = false

	if is_node_ready():
		status_badge.hide()


func get_content_container() -> VBoxContainer:
	return content_container
