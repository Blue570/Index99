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

#@onready var crawler_job_indicator: PanelContainer = (
	#/JobsLayout/CrawlerJobIndicator
#)

@onready var crawler_status_light: ColorRect = (
	$MainApplicationWindow/MainLayout/BackgroundJobsBar
	/JobsLayout/CrawlerJobIndicator
	/CrawlerIndicatorRow/CrawlerStatusLight
)

#@onready var crawler_status_label: Label = (
	#$MainApplicationWindow/MainLayout/BackgroundJobsBar
	#/JobsLayout/CrawlerJobIndicator
	#/CrawlerIndicatorRow/CrawlerStatusLabel
#)

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

@onready var revenue_display: ResourceDisplay = get_node(
	"MainApplicationWindow/MainLayout/ResourceBar/"
	+ "ResourceRow/RevenueDisplay"
) as ResourceDisplay

@onready var users_display: ResourceDisplay = get_node(
	"MainApplicationWindow/MainLayout/ResourceBar/"
	+ "ResourceRow/UsersDisplay"
) as ResourceDisplay

@onready var indexed_pages_display: ResourceDisplay = get_node(
	"MainApplicationWindow/MainLayout/ResourceBar/"
	+ "ResourceRow/IndexedPagesDisplay"
) as ResourceDisplay

@onready var reputation_display: ResourceDisplay = get_node(
	"MainApplicationWindow/MainLayout/ResourceBar/"
	+ "ResourceRow/ReputationDisplay"
) as ResourceDisplay

@onready var server_load_display: ResourceDisplay = get_node(
	"MainApplicationWindow/MainLayout/ResourceBar/"
	+ "ResourceRow/ServerLoadDisplay"
) as ResourceDisplay

@onready var crawler_job_indicator: PanelContainer = get_node(
	"MainApplicationWindow/MainLayout/BackgroundJobsBar/"
	+ "JobsLayout/CrawlerJobIndicator"
) as PanelContainer

@onready var crawler_job_label: Label = get_node(
	"MainApplicationWindow/MainLayout/BackgroundJobsBar/"
	+ "JobsLayout/CrawlerJobIndicator/CrawlerJobLabel"
) as Label




func _ready() -> void:
	apply_theme_foundation()
	connect_title_bar_buttons()
	setup_tabs()
	setup_placeholder_jobs()
	
	setup_background_jobs_connections()
	refresh_background_jobs_bar()
	
	setup_game_state_connections()
	refresh_resource_displays()
	
	open_page(DEFAULT_PAGE_ID)
	
	print(
	"WINDOW SIZE: ",
	get_window().size
)

	print(
	"CONTENT SCALE SIZE: ",
	get_tree().root.content_scale_size
)

	print(
	"ROOT VIEWPORT SIZE: ",
	get_tree().root.get_visible_rect().size
)
	
	
func setup_game_state_connections() -> void:
	if not GameState.revenue_changed.is_connected(
		_on_revenue_changed
	):
		GameState.revenue_changed.connect(
			_on_revenue_changed
		)

	if not GameState.active_users_changed.is_connected(
		_on_active_users_changed
	):
		GameState.active_users_changed.connect(
			_on_active_users_changed
		)

	if not GameState.indexed_pages_changed.is_connected(
		_on_indexed_pages_changed
	):
		GameState.indexed_pages_changed.connect(
			_on_indexed_pages_changed
		)

	if not GameState.reputation_changed.is_connected(
		_on_reputation_changed
	):
		GameState.reputation_changed.connect(
			_on_reputation_changed
		)

	if not GameState.server_load_changed.is_connected(
		_on_server_load_changed
	):
		GameState.server_load_changed.connect(
			_on_server_load_changed
		)
		
		

		
func refresh_resource_displays() -> void:
	_on_revenue_changed(GameState.revenue)
	_on_active_users_changed(GameState.active_users)
	_on_indexed_pages_changed(GameState.indexed_pages)
	_on_reputation_changed(GameState.reputation)
	_on_server_load_changed(GameState.server_load)
	
func _on_revenue_changed(new_value: float) -> void:
	revenue_display.set_display_value(
		format_money(new_value)
	)


func _on_active_users_changed(new_value: int) -> void:
	users_display.set_display_value(
		format_whole_number(new_value)
	)


func _on_indexed_pages_changed(new_value: int) -> void:
	indexed_pages_display.set_display_value(
		format_whole_number(new_value)
	)


func _on_reputation_changed(new_value: float) -> void:
	reputation_display.set_display_value(
		"%.1f" % new_value
	)


func _on_server_load_changed(
	new_value: float
) -> void:
	server_load_display.set_display_value(
		format_percentage(new_value)
	)

	server_load_display.set_display_value_color(
		get_server_load_display_color(new_value)
	)

	refresh_background_jobs_bar()
	
func get_server_load_display_color(
	server_load_value: float
) -> Color:
	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	if server_load_value >= maximum_safe_load:
		return ThemeManager.RESOURCE_VALUE_RED

	if server_load_value >= warning_threshold:
		return ThemeManager.RESOURCE_VALUE_AMBER

	return ThemeManager.RESOURCE_VALUE_BLUE
	
func format_money(value: float) -> String:
	var safe_value: float = maxf(value, 0.0)
	var total_cents: int = roundi(safe_value * 100.0)

	var whole_dollars: int = floori(
		float(total_cents) / 100.0
	)

	var cents: int = total_cents % 100

	return "$%s.%02d" % [
		format_whole_number(whole_dollars),
		cents
	]
	
func format_whole_number(value: int) -> String:
	var number_text: String = str(
		maxi(value, 0)
	)

	var formatted_text: String = ""

	while number_text.length() > 3:
		var split_index: int = (
			number_text.length() - 3
		)

		formatted_text = (
			","
			+ number_text.substr(split_index, 3)
			+ formatted_text
		)

		number_text = number_text.substr(
			0,
			split_index
		)

	return number_text + formatted_text
	
func format_percentage(value: float) -> String:
	var safe_value: float = clampf(
		value,
		0.0,
		100.0
	)

	return "%d%%" % roundi(safe_value)


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
		crawler_job_label,
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
	
func show_background_crawler_warning(
	pages_processed: int,
	target_pages: int,
	server_load_value: float
) -> void:
	crawler_job_label.text = "Crawler: Warning"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	current_job_label.text = (
		"High server load: %d%% — %d / %d pages"
		% [
			roundi(server_load_value),
			pages_processed,
			target_pages
		]
	)
	
func show_background_crawler_overloaded(
	server_load_value: float
) -> void:
	crawler_job_label.text = "Crawler: Auto-Paused"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_ERROR
	)

	current_job_label.text = (
		"Server overload: %d%% — cooling down"
		% roundi(server_load_value)
	)
	
func setup_placeholder_jobs() -> void:
	set_job_indicator(
		crawler_status_light,
		crawler_job_label,
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
	SaveManager.save_game()

	get_tree().quit()
	
func setup_background_jobs_connections() -> void:
	if not CrawlerManager.crawler_state_changed.is_connected(
		_on_background_crawler_state_changed
	):
		CrawlerManager.crawler_state_changed.connect(
			_on_background_crawler_state_changed
		)

	if not CrawlerManager.crawler_progress_changed.is_connected(
		_on_background_crawler_progress_changed
	):
		CrawlerManager.crawler_progress_changed.connect(
			_on_background_crawler_progress_changed
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_background_crawl_job_completed
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_background_crawl_job_completed
		)
		
func refresh_background_jobs_bar() -> void:
	var pages_processed: int = (
		CrawlerManager.current_job_pages
	)

	var target_pages: int = (
		CrawlerManager.get_current_job_target_pages()
	)

	var progress_percent: float = (
		CrawlerManager.get_progress_percent()
	)

	var job_complete: bool = (
		pages_processed >= target_pages
	)

	job_progress.min_value = 0.0
	job_progress.max_value = 100.0
	job_progress.step = 1.0
	job_progress.show_percentage = true
	job_progress.value = progress_percent

	if job_complete:
		show_background_crawler_complete(
			pages_processed
		)

	elif CrawlerManager.paused_for_overload:
		show_background_crawler_overloaded(
			GameState.server_load
		)

	elif (
		GameState.crawler_running
		and GameState.server_load
		>= CrawlerManager.get_effective_warning_threshold()
	):
		show_background_crawler_warning(
			pages_processed,
			target_pages,
			GameState.server_load
		)

	elif GameState.crawler_running:
		show_background_crawler_running(
			pages_processed,
			target_pages
		)

	elif pages_processed > 0:
		show_background_crawler_paused(
			pages_processed,
			target_pages
		)

	else:
		show_background_crawler_idle()
	
func show_background_crawler_idle() -> void:
	crawler_job_label.text = "Crawler: Idle"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	current_job_label.text = "No active background job"
	job_progress.value = 0.0


func show_background_crawler_running(
	pages_processed: int,
	target_pages: int
) -> void:
	crawler_job_label.text = "Crawler: Running"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	current_job_label.text = (
		"Crawling public web pages — %d / %d pages"
		% [
			pages_processed,
			target_pages
		]
	)


func show_background_crawler_paused(
	pages_processed: int,
	target_pages: int
) -> void:
	crawler_job_label.text = "Crawler: Paused"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	current_job_label.text = (
		"Crawler paused — %d / %d pages"
		% [
			pages_processed,
			target_pages
		]
	)


func show_background_crawler_complete(
	pages_processed: int
) -> void:
	crawler_job_label.text = "Crawler: Complete"

	crawler_job_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	current_job_label.text = (
		"Crawl complete — %d pages indexed"
		% pages_processed
	)

	job_progress.value = 100.0
	
func _on_background_crawler_state_changed(
	_is_running: bool
) -> void:
	refresh_background_jobs_bar()


func _on_background_crawler_progress_changed(
	_pages_processed: int,
	_target_pages: int,
	_progress_percent: float
) -> void:
	refresh_background_jobs_bar()


func _on_background_crawl_job_completed() -> void:
	refresh_background_jobs_bar()
	
