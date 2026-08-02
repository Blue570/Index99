extends Node

# ============================================================
# INDEX 99 COLOR PALETTE
# ============================================================
#
# All interface colors should eventually come from this file.
# Avoid scattering hard-coded colors throughout other scripts.


# Desktop and application surfaces
const DESKTOP_BACKGROUND := Color("#263F4A")
const WINDOW_BACKGROUND := Color("#C0C0C0")
const PANEL_BACKGROUND := Color("#D6D6D6")
const CONTENT_BACKGROUND := Color("#ECECEC")
const SUNKEN_BACKGROUND := Color("#FFFFFF")


# Title bars and primary accents
const TITLE_BAR_ACTIVE := Color("#17365D")
const TITLE_BAR_INACTIVE := Color("#59697A")
const TITLE_BAR_BORDER := Color("#0B1D35")
const ACCENT_BLUE := Color("#285E9A")
const ACCENT_BLUE_LIGHT := Color("#D8E8F7")


# Text
const TEXT_PRIMARY := Color("#202020")
const TEXT_SECONDARY := Color("#555555")
const TEXT_DISABLED := Color("#808080")
const TEXT_LIGHT := Color("#FFFFFF")
const LINK_BLUE := Color("#0000CC")


# Status colors
const STATUS_SUCCESS := Color("#2F8F46")
const STATUS_WARNING := Color("#C58A13")
const STATUS_ERROR := Color("#B33A3A")
const STATUS_INFORMATION := Color("#285E9A")


# Retro border colors
const BORDER_HIGHLIGHT := Color("#FFFFFF")
const BORDER_LIGHT := Color("#DFDFDF")
const BORDER_DARK := Color("#808080")
const BORDER_SHADOW := Color("#404040")


# Charts
const CHART_GRID := Color("#C8C8C8")
const CHART_LINE_BLUE := Color("#285E9A")
const CHART_LINE_GREEN := Color("#2F8F46")
const CHART_LINE_AMBER := Color("#C58A13")


# Values
const RESOURCE_VALUE_BLUE := Color("#285E9A")
const RESOURCE_VALUE_GREEN := Color("#2F8F46")
const RESOURCE_VALUE_AMBER := Color("#C58A13")
const RESOURCE_VALUE_RED := Color("#B33A3A")


# ============================================================
# FONT SIZES
# ============================================================

const FONT_SIZE_SMALL := 12
const FONT_SIZE_NORMAL := 14
const FONT_SIZE_TITLE := 18
const FONT_SIZE_SECTION_HEADER := 16
const FONT_SIZE_LARGE_VALUE := 24


# ============================================================
# STANDARD SPACING
# ============================================================

const SPACING_TINY := 2
const SPACING_SMALL := 4
const SPACING_NORMAL := 8
const SPACING_LARGE := 12
const SPACING_SECTION := 16


# ============================================================
# STYLE FACTORIES
# ============================================================

func create_base_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = WINDOW_BACKGROUND

	style.border_color = BORDER_SHADOW
	style.set_border_width_all(2)

	style.content_margin_left = 4.0
	style.content_margin_top = 4.0
	style.content_margin_right = 4.0
	style.content_margin_bottom = 4.0

	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0

	style.anti_aliasing = false

	return style


func create_title_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = TITLE_BAR_ACTIVE

	style.border_color = TITLE_BAR_BORDER
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 2

	style.content_margin_left = 8.0
	style.content_margin_top = 4.0
	style.content_margin_right = 8.0
	style.content_margin_bottom = 4.0

	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0

	style.anti_aliasing = false

	return style
	
func create_resource_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = PANEL_BACKGROUND
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 6.0
	style.content_margin_top = 5.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_resource_display_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#E4E4E4")
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 6.0
	style.content_margin_top = 4.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 4.0

	style.anti_aliasing = false

	return style


func create_resource_icon_style(accent_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = accent_color
	style.border_color = TITLE_BAR_BORDER
	style.set_border_width_all(1)

	style.content_margin_left = 2.0
	style.content_margin_top = 2.0
	style.content_margin_right = 2.0
	style.content_margin_bottom = 2.0

	style.anti_aliasing = false

	return style


func create_window_button_normal_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = WINDOW_BACKGROUND
	style.border_color = BORDER_SHADOW
	style.set_border_width_all(1)

	style.content_margin_left = 4.0
	style.content_margin_top = 2.0
	style.content_margin_right = 4.0
	style.content_margin_bottom = 2.0

	style.anti_aliasing = false

	return style


func create_window_button_hover_style(
	danger: bool = false
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = STATUS_ERROR if danger else BORDER_LIGHT
	style.border_color = BORDER_HIGHLIGHT
	style.set_border_width_all(1)

	style.content_margin_left = 4.0
	style.content_margin_top = 2.0
	style.content_margin_right = 4.0
	style.content_margin_bottom = 2.0

	style.anti_aliasing = false

	return style


func create_window_button_pressed_style(
	danger: bool = false
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#7E2727") if danger else BORDER_DARK
	style.border_color = BORDER_SHADOW
	style.set_border_width_all(1)

	style.content_margin_left = 5.0
	style.content_margin_top = 3.0
	style.content_margin_right = 3.0
	style.content_margin_bottom = 1.0

	style.anti_aliasing = false

	return style
	
func create_tab_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = PANEL_BACKGROUND
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 4.0
	style.content_margin_top = 3.0
	style.content_margin_right = 4.0
	style.content_margin_bottom = 3.0

	style.anti_aliasing = false

	return style


func create_tab_inactive_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = WINDOW_BACKGROUND
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 10.0
	style.content_margin_top = 5.0
	style.content_margin_right = 10.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_tab_hover_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = BORDER_LIGHT
	style.border_color = ACCENT_BLUE
	style.set_border_width_all(1)

	style.content_margin_left = 10.0
	style.content_margin_top = 5.0
	style.content_margin_right = 10.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_tab_active_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = CONTENT_BACKGROUND
	style.border_color = ACCENT_BLUE

	style.border_width_left = 1
	style.border_width_top = 3
	style.border_width_right = 1
	style.border_width_bottom = 1

	style.content_margin_left = 10.0
	style.content_margin_top = 4.0
	style.content_margin_right = 10.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_tab_focus_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style.border_color = ACCENT_BLUE
	style.set_border_width_all(2)

	style.anti_aliasing = false

	return style


func create_page_background_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = CONTENT_BACKGROUND
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 12.0
	style.content_margin_top = 12.0
	style.content_margin_right = 12.0
	style.content_margin_bottom = 12.0

	style.anti_aliasing = false

	return style
	
func create_background_jobs_bar_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#C6C6C6")
	style.border_color = BORDER_DARK

	style.border_width_left = 1
	style.border_width_top = 2
	style.border_width_right = 1
	style.border_width_bottom = 1

	style.content_margin_left = 6.0
	style.content_margin_top = 5.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_job_indicator_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#DADADA")
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 6.0
	style.content_margin_top = 3.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 3.0

	style.anti_aliasing = false

	return style


func create_job_progress_background_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#FFFFFF")
	style.border_color = BORDER_SHADOW
	style.set_border_width_all(1)

	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0

	style.anti_aliasing = false

	return style


func create_job_progress_fill_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = ACCENT_BLUE
	style.border_color = TITLE_BAR_BORDER
	style.set_border_width_all(1)

	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0

	style.anti_aliasing = false

	return style
	
func create_section_panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = WINDOW_BACKGROUND
	style.border_color = BORDER_SHADOW
	style.set_border_width_all(1)

	style.content_margin_left = 2.0
	style.content_margin_top = 2.0
	style.content_margin_right = 2.0
	style.content_margin_bottom = 2.0

	style.anti_aliasing = false

	return style


func create_section_header_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = TITLE_BAR_INACTIVE
	style.border_color = TITLE_BAR_BORDER
	style.set_border_width_all(1)

	style.content_margin_left = 8.0
	style.content_margin_top = 4.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 4.0

	style.anti_aliasing = false

	return style


func create_section_content_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = CONTENT_BACKGROUND
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 0.0
	style.content_margin_top = 0.0
	style.content_margin_right = 0.0
	style.content_margin_bottom = 0.0

	style.anti_aliasing = false

	return style


func create_status_badge_style(
	badge_color: Color = ACCENT_BLUE
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = badge_color
	style.border_color = TITLE_BAR_BORDER
	style.set_border_width_all(1)

	style.content_margin_left = 5.0
	style.content_margin_top = 2.0
	style.content_margin_right = 5.0
	style.content_margin_bottom = 2.0

	style.anti_aliasing = false

	return style
	
func create_dashboard_inset_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#F4F4F4")
	style.border_color = BORDER_DARK
	style.set_border_width_all(1)

	style.content_margin_left = 6.0
	style.content_margin_top = 6.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 6.0

	style.anti_aliasing = false

	return style


func create_dashboard_metric_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#E8E8E8")
	style.border_color = BORDER_LIGHT
	style.set_border_width_all(1)

	style.content_margin_left = 6.0
	style.content_margin_top = 4.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 4.0

	style.anti_aliasing = false

	return style


func create_dashboard_event_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#F2F2F2")
	style.border_color = BORDER_LIGHT

	style.border_width_left = 0
	style.border_width_top = 0
	style.border_width_right = 0
	style.border_width_bottom = 1

	style.content_margin_left = 6.0
	style.content_margin_top = 5.0
	style.content_margin_right = 6.0
	style.content_margin_bottom = 5.0

	style.anti_aliasing = false

	return style


func create_dashboard_progress_background_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = Color("#FFFFFF")
	style.border_color = BORDER_SHADOW
	style.set_border_width_all(1)

	style.anti_aliasing = false

	return style


func create_dashboard_progress_fill_style(
	fill_color: Color = ACCENT_BLUE
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()

	style.bg_color = fill_color
	style.border_color = TITLE_BAR_BORDER
	style.set_border_width_all(1)

	style.anti_aliasing = false

	return style
