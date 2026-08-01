extends Control

const DEFAULT_PAGE_ID: StringName = &"dashboard"

var tab_buttons: Dictionary = {}
var pages: Dictionary = {}
var current_page_id: StringName = &""

@onready var desktop_background := (
	get_node("DesktopBackground") as ColorRect
)

@onready var main_application_window := (
	get_node("MainApplicationWindow") as PanelContainer
)

@onready var title_bar := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar"
	) as PanelContainer
)

@onready var title_bar_layout := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/TitleBarLayout"
	) as HBoxContainer
)

@onready var app_icon_frame := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/AppIconFrame"
	) as PanelContainer
)

@onready var app_icon_label := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/AppIconFrame/AppIconLabel"
	) as Label
)

@onready var title_label := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/TitleLabel"
	) as Label
)

@onready var build_label := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/BuildLabel"
	) as Label
)

@onready var window_controls := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/WindowControls"
	) as HBoxContainer
)

@onready var minimize_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/WindowControls/MinimizeButton"
	) as Button
)

@onready var maximize_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/WindowControls/MaximizeButton"
	) as Button
)

@onready var close_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/WindowControls/CloseButton"
	) as Button
)

@onready var resource_bar := (
	get_node(
		"MainApplicationWindow/MainLayout/ResourceBar"
	) as PanelContainer
)

@onready var resource_row := (
	get_node(
		"MainApplicationWindow/MainLayout/ResourceBar/ResourceRow"
	) as HBoxContainer
)

@onready var tab_bar := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar"
	) as PanelContainer
)

@onready var tab_row := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/TabRow"
	) as HBoxContainer
)

@onready var dashboard_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/DashboardTab"
	) as TabButton
)

@onready var crawler_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/CrawlerTab"
	) as TabButton
)

@onready var index_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/IndexTab"
	) as TabButton
)

@onready var servers_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/ServersTab"
	) as TabButton
)

@onready var research_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/ResearchTab"
	) as TabButton
)

@onready var dashboard_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/DashboardPage"
	) as PanelContainer
)

@onready var crawler_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/CrawlerPage"
	) as PanelContainer
)

@onready var index_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/IndexPage"
	) as PanelContainer
)

@onready var servers_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/ServersPage"
	) as PanelContainer
)

@onready var research_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/ResearchPage"
	) as PanelContainer
)

@onready var background_jobs_bar: PanelContainer = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
)

@onready var jobs_layout: HBoxContainer = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar/JobsLayout
)

@onready var jobs_title_label: Label = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/JobsTitleLabel
)

@onready var crawler_job_indicator: PanelContainer = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/CrawlerJobIndicator
)

@onready var crawler_status_light: ColorRect = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/CrawlerJobIndicator
	/CrawlerIndicatorRow/CrawlerStatusLight
)

@onready var crawler_status_label: Label = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/CrawlerJobIndicator
	/CrawlerIndicatorRow/CrawlerStatusLabel
)

@onready var indexer_job_indicator: PanelContainer = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/IndexerJobIndicator
)

@onready var indexer_status_light: ColorRect = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/IndexerJobIndicator
	/IndexerIndicatorRow/IndexerStatusLight
)

@onready var indexer_status_label: Label = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/IndexerJobIndicator
	/IndexerIndicatorRow/IndexerStatusLabel
)

@onready var research_job_indicator: PanelContainer = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/ResearchJobIndicator
)

@onready var research_status_light: ColorRect = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/ResearchJobIndicator
	/ResearchIndicatorRow/ResearchStatusLight
)

@onready var research_status_label: Label = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/ResearchJobIndicator
	/ResearchIndicatorRow/ResearchStatusLabel
)

@onready var current_job_label: Label = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/CurrentJobLabel
)

@onready var job_progress: ProgressBar = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/JobProgress
)


func _ready() -> void:
	apply_theme_foundation()
	connect_title_bar_buttons()
	setup_tabs()
	setup_placeholder_jobs()
	open_page(DEFAULT_PAGE_ID)


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

	tab_bar.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_tab_bar_style()
	)

	title_bar_layout.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	resource_row.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_SMALL
	)

	tab_row.add_theme_constant_override(
		"separation",
		ThemeManager.SPACING_TINY
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

	var page_panels: Array[PanelContainer] = [
		dashboard_page,
		crawler_page,
		index_page,
		servers_page,
		research_page
	]

	for page: PanelContainer in page_panels:
		page.add_theme_stylebox_override(
			"panel",
			ThemeManager.create_page_background_style()
		)
		
	apply_background_jobs_theme()
	apply_window_button_styles()

func apply_background_jobs_theme() -> void:
	background_jobs_bar.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_background_jobs_bar_style()
	)

	jobs_layout.add_theme_constant_override(
		"separation",
		6
	)

	jobs_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	jobs_title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	var indicator_panels: Array[PanelContainer] = [
		crawler_job_indicator,
		indexer_job_indicator,
		research_job_indicator
	]

	for indicator: PanelContainer in indicator_panels:
		indicator.add_theme_stylebox_override(
			"panel",
			ThemeManager.create_job_indicator_style()
		)

	var indicator_labels: Array[Label] = [
		crawler_status_label,
		indexer_status_label,
		research_status_label
	]

	for indicator_label: Label in indicator_labels:
		indicator_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

		indicator_label.add_theme_font_size_override(
			"font_size",
			ThemeManager.FONT_SIZE_SMALL
		)

	current_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	current_job_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	job_progress.add_theme_stylebox_override(
		"background",
		ThemeManager.create_job_progress_background_style()
	)

	job_progress.add_theme_stylebox_override(
		"fill",
		ThemeManager.create_job_progress_fill_style()
	)

	job_progress.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	job_progress.add_theme_color_override(
		"font_outline_color",
		ThemeManager.TITLE_BAR_BORDER
	)

	job_progress.add_theme_constant_override(
		"outline_size",
		1
	)

	job_progress.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)
	
func setup_placeholder_jobs() -> void:
	set_job_indicator(
		crawler_status_light,
		crawler_status_label,
		"Crawler: Running",
		ThemeManager.STATUS_SUCCESS
	)

	set_job_indicator(
		indexer_status_light,
		indexer_status_label,
		"Indexer: Idle",
		ThemeManager.TEXT_DISABLED
	)

	set_job_indicator(
		research_status_light,
		research_status_label,
		"Research: Queued",
		ThemeManager.STATUS_WARNING
	)

	current_job_label.text = "Indexing batch 0042"

	job_progress.min_value = 0.0
	job_progress.max_value = 100.0
	job_progress.step = 1.0
	job_progress.value = 42.0
	job_progress.show_percentage = true
	job_progress.indeterminate = false
	
func set_job_indicator(
	status_light: ColorRect,
	status_label: Label,
	label_text: String,
	status_color: Color
) -> void:
	status_light.color = status_color
	status_label.text = label_text

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


func setup_tabs() -> void:
	tab_buttons = {
		&"dashboard": dashboard_tab,
		&"crawler": crawler_tab,
		&"index": index_tab,
		&"servers": servers_tab,
		&"research": research_tab
	}

	pages = {
		&"dashboard": dashboard_page,
		&"crawler": crawler_page,
		&"index": index_page,
		&"servers": servers_page,
		&"research": research_page
	}

	for tab_id: StringName in tab_buttons:
		var tab_button := tab_buttons[tab_id] as TabButton

		if not tab_button.tab_selected.is_connected(
			_on_tab_selected
		):
			tab_button.tab_selected.connect(
				_on_tab_selected
			)


func open_page(page_id: StringName) -> void:
	if not pages.has(page_id):
		push_warning(
			"Unknown page ID: %s" % page_id
		)
		return

	if not tab_buttons.has(page_id):
		push_warning(
			"No tab button exists for page ID: %s" % page_id
		)
		return

	current_page_id = page_id

	for stored_page_id: StringName in pages:
		var page := pages[stored_page_id] as Control
		page.visible = stored_page_id == page_id

	for stored_tab_id: StringName in tab_buttons:
		var tab_button := (
			tab_buttons[stored_tab_id] as TabButton
		)

		tab_button.set_active(
			stored_tab_id == page_id
		)


func _on_tab_selected(tab_id: StringName) -> void:
	open_page(tab_id)


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
