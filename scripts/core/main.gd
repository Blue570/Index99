extends Control

const DEFAULT_PAGE_ID: StringName = &"dashboard"

const PAGE_SHORTCUTS: Dictionary = {
	KEY_1: &"dashboard",
	KEY_2: &"crawler",
	KEY_3: &"jobs",
	KEY_4: &"index",
	KEY_5: &"servers",
	KEY_6: &"research",
	KEY_7: &"upgrades",
	KEY_8: &"activities"
}

# -------------------------------------------------------------------
# Application Menu IDs
# -------------------------------------------------------------------

const FILE_MENU_SAVE_GAME: int = 100
const FILE_MENU_EXIT: int = 101

const VIEW_MENU_SESSION_STATISTICS: int = 200

const TOOLS_MENU_OPTIONS: int = 300
const TOOLS_MENU_KEYBOARD_SHORTCUTS: int = 301

const HELP_MENU_RESTART_TUTORIAL: int = 400
const HELP_MENU_HOW_TO_PLAY: int = 401
const HELP_MENU_ABOUT: int = 402

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

@onready var application_menu_row := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/ApplicationMenuRow"
	) as HBoxContainer
)

@onready var file_menu_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/ApplicationMenuRow/"
		+ "FileMenuButton"
	) as MenuButton
)

@onready var view_menu_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/ApplicationMenuRow/"
		+ "ViewMenuButton"
	) as MenuButton
)

@onready var tools_menu_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/ApplicationMenuRow/"
		+ "ToolsMenuButton"
	) as MenuButton
)

@onready var help_menu_button := (
	get_node(
		"MainApplicationWindow/MainLayout/TitleBar/"
		+ "TitleBarLayout/ApplicationMenuRow/"
		+ "HelpMenuButton"
	) as MenuButton
)

@onready var build_label: Label = get_node(
	"MainApplicationWindow/MainLayout/TitleBar/"
	+ "TitleBarLayout/BuildLabel"
) as Label

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

@onready var jobs_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/JobsTab"
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

@onready var upgrades_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/UpgradesTab"
	) as TabButton
)

@onready var activities_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/ActivitiesTab"
	) as TabButton
)

@onready var tech_tab := (
	get_node(
		"MainApplicationWindow/MainLayout/TabBar/"
		+ "TabRow/TechTab"
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

@onready var jobs_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/CrawlerJobsPage"
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

@onready var upgrades_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/UpgradesPage"
	) as PanelContainer
)

@onready var activities_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/ActivitiesPage"
	) as PanelContainer
)

@onready var tech_tree_page := (
	get_node(
		"MainApplicationWindow/MainLayout/PageArea/"
		+ "PageStack/TechTreePage"
	) as Control
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

# -------------------------------------------------------------------
# Session Statistics Window
# -------------------------------------------------------------------

@onready var session_statistics_window := (
	get_node(
		"SessionStatisticsWindow"
	) as PanelContainer
)

@onready var session_statistics_close_button := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsHeaderPanel/"
		+ "SessionStatisticsHeader/"
		+ "SessionStatisticsCloseButton"
	) as Button
)

@onready var session_statistics_footer_close_button := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsFooter/"
		+ "SessionStatisticsFooterCloseButton"
	) as Button
)

@onready var session_time_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "SessionTimeValueLabel"
	) as Label
)

@onready var pages_indexed_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "PagesIndexedValueLabel"
	) as Label
)

@onready var revenue_earned_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "RevenueEarnedValueLabel"
	) as Label
)

@onready var active_users_gained_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "ActiveUsersGainedValueLabel"
	) as Label
)

@onready var crawls_completed_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "CrawlsCompletedValueLabel"
	) as Label
)

@onready var manual_assists_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "ManualAssistsValueLabel"
	) as Label
)

@onready var auto_throttle_actions_value_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid/"
		+ "AutoThrottleActionsValueLabel"
	) as Label
)

@onready var session_statistics_header_panel := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsHeaderPanel"
	) as PanelContainer
)

@onready var session_statistics_title_label := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsHeaderPanel/"
		+ "SessionStatisticsHeader/"
		+ "SessionStatisticsTitleLabel"
	) as Label
)

@onready var session_statistics_header_separator := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsHeaderSeparator"
	) as HSeparator
)

@onready var session_statistics_grid := (
	get_node(
		"SessionStatisticsWindow/"
		+ "SessionStatisticsMargin/"
		+ "SessionStatisticsLayout/"
		+ "SessionStatisticsGrid"
	) as GridContainer
)


func setup_application_menu_popup_theme() -> void:
	var active_theme: Theme = theme

	if active_theme == null:
		active_theme = Theme.new()
		theme = active_theme

	# ---------------------------------------------------------------
	# Popup background
	# ---------------------------------------------------------------

	var popup_panel_style: StyleBoxFlat = StyleBoxFlat.new()

	popup_panel_style.bg_color = Color(
		0.78,
		0.78,
		0.78,
		1.0
	)

	popup_panel_style.border_color = Color(
		0.18,
		0.18,
		0.20,
		1.0
	)

	popup_panel_style.set_border_width_all(
		1
	)

	popup_panel_style.content_margin_left = 3.0
	popup_panel_style.content_margin_right = 3.0
	popup_panel_style.content_margin_top = 3.0
	popup_panel_style.content_margin_bottom = 3.0


# ---------------------------------------------------------------
# Hover / selected item
# ---------------------------------------------------------------

	var popup_hover_style: StyleBoxFlat = (
		StyleBoxFlat.new()
)

	popup_hover_style.bg_color = (
		ThemeManager.ACCENT_BLUE
)

	popup_hover_style.border_color = (
		ThemeManager.ACCENT_BLUE_LIGHT
)

	popup_hover_style.set_border_width_all(
		1
)


# ---------------------------------------------------------------
# Separator
# ---------------------------------------------------------------

	var popup_separator_style: StyleBoxLine = (
		StyleBoxLine.new()
)

	popup_separator_style.color = Color(
		0.35,
		0.35,
		0.38,
		1.0
)

	popup_separator_style.thickness = 1


# ---------------------------------------------------------------
# Apply PopupMenu theme
# ---------------------------------------------------------------

	active_theme.set_stylebox(
	"panel",
	"PopupMenu",
	popup_panel_style
)

	active_theme.set_stylebox(
	"hover",
	"PopupMenu",
	popup_hover_style
)

	active_theme.set_stylebox(
	"separator",
	"PopupMenu",
	popup_separator_style
)


# ---------------------------------------------------------------
# Text colors
# ---------------------------------------------------------------

	active_theme.set_color(
	"font_color",
	"PopupMenu",
	Color(
		0.08,
		0.08,
		0.08,
		1.0
	)
)

	active_theme.set_color(
	"font_hover_color",
	"PopupMenu",
	ThemeManager.TEXT_LIGHT
)

	active_theme.set_color(
	"font_disabled_color",
	"PopupMenu",
	Color(
		0.42,
		0.42,
		0.42,
		1.0
	)
)

	active_theme.set_color(
	"font_separator_color",
	"PopupMenu",
	Color(
		0.35,
		0.35,
		0.38,
		1.0
	)
)


# ---------------------------------------------------------------
# Future keyboard accelerator colors
# ---------------------------------------------------------------

	active_theme.set_color(
	"font_accelerator_color",
	"PopupMenu",
	Color(
		0.25,
		0.25,
		0.27,
		1.0
	)
)

	active_theme.set_color(
	"font_accelerator_hover_color",
	"PopupMenu",
	ThemeManager.TEXT_LIGHT
)

	active_theme.set_color(
	"font_accelerator_disabled_color",
	"PopupMenu",
	Color(
		0.45,
		0.45,
		0.45,
		1.0
	)
)


# ---------------------------------------------------------------
# Font and spacing
# ---------------------------------------------------------------

	active_theme.set_font_size(
	"font_size",
	"PopupMenu",
	ThemeManager.FONT_SIZE_SMALL
)

	active_theme.set_constant(
	"item_start_padding",
	"PopupMenu",
	8
)

	active_theme.set_constant(
	"item_end_padding",
	"PopupMenu",
	10
)

	active_theme.set_constant(
	"h_separation",
	"PopupMenu",
	8
)

	active_theme.set_constant(
	"v_separation",
	"PopupMenu",
	4
)

	active_theme.set_constant(
	"separator_height",
	"PopupMenu",
	7
)


	# ---------------------------------------------------------------
	# Apply theme to application popups
	# ---------------------------------------------------------------

	var application_popups: Array[PopupMenu] = [
		file_menu_button.get_popup(),
		view_menu_button.get_popup(),
		tools_menu_button.get_popup(),
		help_menu_button.get_popup()
	]

	for popup: PopupMenu in application_popups:
		popup.theme = active_theme




func _ready() -> void:
	apply_theme_foundation()
	setup_tooltip_theme()
	connect_title_bar_buttons()
	setup_application_menus()
	setup_tabs()
	setup_activities_unlock()
	setup_tech_tree_unlock()
	setup_placeholder_jobs()
	setup_application_menu_popup_theme()
	setup_session_statistics_window()

	setup_background_jobs_connections()
	refresh_background_jobs_bar()

	setup_game_state_connections()
	refresh_resource_displays()
	setup_resource_tooltips()

	setup_build_number_display()

	open_page(
		DEFAULT_PAGE_ID
	)
	
func setup_build_number_display() -> void:
	if not BuildManager.build_number_changed.is_connected(
		_on_build_number_changed
	):
		BuildManager.build_number_changed.connect(
			_on_build_number_changed
		)

	refresh_build_number_display()
	
func _on_build_number_changed(
	_major: int,
	_minor: int,
	_patch: int
) -> void:
	refresh_build_number_display()
	
func refresh_build_number_display() -> void:
	build_label.text = (
		"BUILD "
		+ BuildManager.get_build_number_text()
	)

	build_label.tooltip_text = (
		"Current Index 99 system build."
	)

	# ---------------------------------------------------------------
	# Popup background
	# ---------------------------------------------------------------

	var popup_panel_style: StyleBoxFlat = StyleBoxFlat.new()

	popup_panel_style.bg_color = Color(
		0.78,
		0.78,
		0.78,
		1.0
	)

	popup_panel_style.border_color = Color(
		0.18,
		0.18,
		0.20,
		1.0
	)

	popup_panel_style.set_border_width_all(1)

	popup_panel_style.content_margin_left = 3.0
	popup_panel_style.content_margin_right = 3.0
	popup_panel_style.content_margin_top = 3.0
	popup_panel_style.content_margin_bottom = 3.0
	
	
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

	if not ServerManager.maximum_safe_load_level_changed.is_connected(
		_on_resource_maximum_safe_load_level_changed
	):
		ServerManager.maximum_safe_load_level_changed.connect(
			_on_resource_maximum_safe_load_level_changed
		)
		
func _on_resource_maximum_safe_load_level_changed(
	_new_level: int
) -> void:
	_on_server_load_changed(
		GameState.server_load
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
	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	var safe_load: float = clampf(
		new_value,
		0.0,
		maximum_safe_load
	)

	server_load_display.set_display_value(
		"%d%% / %d%%"
		% [
			roundi(safe_load),
			roundi(maximum_safe_load)
		]
	)

	server_load_display.set_display_value_color(
		get_server_load_display_color(
			safe_load
		)
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
	
# -------------------------------------------------------------------
# Session Statistics Window
# -------------------------------------------------------------------

func setup_session_statistics_window() -> void:
	session_statistics_window.visible = false

	apply_session_statistics_theme()

	if not session_statistics_close_button.pressed.is_connected(
		_on_session_statistics_close_pressed
	):
		session_statistics_close_button.pressed.connect(
			_on_session_statistics_close_pressed
		)

	if not session_statistics_footer_close_button.pressed.is_connected(
		_on_session_statistics_close_pressed
	):
		session_statistics_footer_close_button.pressed.connect(
			_on_session_statistics_close_pressed
		)

	if not SessionStatsManager.session_statistics_changed.is_connected(
		_on_session_statistics_changed
	):
		SessionStatsManager.session_statistics_changed.connect(
			_on_session_statistics_changed
		)

	if not SessionStatsManager.session_time_changed.is_connected(
		_on_session_time_changed
	):
		SessionStatsManager.session_time_changed.connect(
			_on_session_time_changed
		)

	refresh_session_statistics_display()
		
func open_session_statistics_window() -> void:
	refresh_session_statistics_display()

	session_statistics_window.visible = true
	session_statistics_window.move_to_front()
	
func close_session_statistics_window() -> void:
	session_statistics_window.visible = false
	
func _on_session_statistics_close_pressed() -> void:
	close_session_statistics_window()
	
func refresh_session_statistics_display() -> void:
	session_time_value_label.text = (
		format_session_time(
			SessionStatsManager.get_session_time_seconds()
		)
	)

	pages_indexed_value_label.text = (
		format_whole_number(
			SessionStatsManager.get_pages_indexed()
		)
	)

	revenue_earned_value_label.text = (
		format_money(
			SessionStatsManager.get_revenue_earned()
		)
	)

	active_users_gained_value_label.text = (
		format_whole_number(
			SessionStatsManager.get_active_users_gained()
		)
	)

	crawls_completed_value_label.text = (
		format_whole_number(
			SessionStatsManager.get_crawls_completed()
		)
	)

	manual_assists_value_label.text = (
		format_whole_number(
			SessionStatsManager.get_manual_assists_used()
		)
	)

	auto_throttle_actions_value_label.text = (
		format_whole_number(
			SessionStatsManager.get_auto_throttle_actions()
		)
	)
	
func _on_session_statistics_changed() -> void:
	refresh_session_statistics_display()


func _on_session_time_changed(
	_total_seconds: int
) -> void:
	refresh_session_statistics_display()
	
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
	
func format_session_time(
	total_seconds: int
) -> String:
	var safe_seconds: int = maxi(
		total_seconds,
		0
	)

	var hours: int = (
		safe_seconds / 3600
	)

	var minutes: int = (
		(safe_seconds % 3600) / 60
	)

	var seconds: int = (
		safe_seconds % 60
	)

	return "%02d:%02d:%02d" % [
		hours,
		minutes,
		seconds
	]
	
func setup_resource_tooltips() -> void:
	revenue_display.tooltip_text = (
		"Revenue\n\n"
		+ "Money earned primarily by indexing pages.\n"
		+ "Used to purchase server and automation upgrades."
	)

	users_display.tooltip_text = (
		"Active Users\n\n"
		+ "Estimated users currently using the search service.\n"
		+ "Indexing pages attracts new users, and research can "
		+ "increase the number gained per page."
	)

	indexed_pages_display.tooltip_text = (
		"Indexed Pages\n\n"
		+ "Total number of web pages added to the search index.\n"
		+ "Increasing this value contributes to progression, "
		+ "objectives, and indexing milestones."
	)

	reputation_display.tooltip_text = (
		"Reputation\n\n"
		+ "Represents the overall standing and credibility "
		+ "of the search service."
	)

	server_load_display.tooltip_text = (
		"Server Load\n\n"
		+ "Current workload placed on the server infrastructure.\n"
		+ "High load can trigger warnings and eventually force "
		+ "the crawler to pause while the servers cool."
	)


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
	
func setup_tooltip_theme() -> void:
	var active_theme: Theme = theme

	if active_theme == null:
		active_theme = Theme.new()
		theme = active_theme

	var tooltip_style: StyleBoxFlat = StyleBoxFlat.new()

	tooltip_style.bg_color = Color(
		0.16,
		0.16,
		0.18,
		1.0
	)

	tooltip_style.border_color = Color(
		0.38,
		0.38,
		0.42,
		1.0
	)

	tooltip_style.set_border_width_all(1)

	tooltip_style.content_margin_left = 8.0
	tooltip_style.content_margin_right = 8.0
	tooltip_style.content_margin_top = 6.0
	tooltip_style.content_margin_bottom = 6.0

	active_theme.set_stylebox(
		"panel",
		"TooltipPanel",
		tooltip_style
	)

	active_theme.set_color(
		"font_color",
		"TooltipLabel",
		Color(
			0.92,
			0.92,
			0.92,
			1.0
		)
	)

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
	
	
# -------------------------------------------------------------------
# Application Menus
# -------------------------------------------------------------------

func setup_application_menus() -> void:
	setup_file_menu()
	setup_view_menu()
	setup_tools_menu()
	setup_help_menu()
	
func setup_file_menu() -> void:
	var popup: PopupMenu = (
		file_menu_button.get_popup()
	)

	popup.clear()

	popup.add_item(
		"Save Game",
		FILE_MENU_SAVE_GAME
	)

	popup.add_separator()

	popup.add_item(
		"Exit",
		FILE_MENU_EXIT
	)

	if not popup.id_pressed.is_connected(
		_on_file_menu_id_pressed
	):
		popup.id_pressed.connect(
			_on_file_menu_id_pressed
		)
	
func _on_file_menu_id_pressed(
	item_id: int
) -> void:
	match item_id:
		FILE_MENU_SAVE_GAME:
			SaveManager.save_game()

		FILE_MENU_EXIT:
			_on_close_button_pressed()
			
func setup_view_menu() -> void:
	var popup: PopupMenu = (
		view_menu_button.get_popup()
	)

	popup.clear()

	popup.add_item(
		"Session Statistics",
		VIEW_MENU_SESSION_STATISTICS
	)

	if not popup.id_pressed.is_connected(
		_on_view_menu_id_pressed
	):
		popup.id_pressed.connect(
			_on_view_menu_id_pressed
		)
		
func _on_view_menu_id_pressed(
	item_id: int
) -> void:
	match item_id:
		VIEW_MENU_SESSION_STATISTICS:
			open_session_statistics_window()
			
func apply_session_statistics_theme() -> void:
	session_statistics_window.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_base_panel_style()
	)

	session_statistics_header_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_title_bar_style()
	)

	session_statistics_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	session_statistics_title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_TITLE
	)

	session_statistics_grid.add_theme_constant_override(
		"h_separation",
		32
	)

	session_statistics_grid.add_theme_constant_override(
		"v_separation",
		10
	)

	var statistics_labels: Array[Node] = (
		session_statistics_grid.get_children()
	)

	for label_index: int in range(
		statistics_labels.size()
	):
		var statistic_label := (
			statistics_labels[label_index] as Label
		)

		if statistic_label == null:
			continue

		statistic_label.add_theme_font_size_override(
			"font_size",
			ThemeManager.FONT_SIZE_SMALL
		)

		if label_index % 2 == 0:
			statistic_label.add_theme_color_override(
				"font_color",
				ThemeManager.TEXT_SECONDARY
			)

		else:
			statistic_label.add_theme_color_override(
				"font_color",
				ThemeManager.TEXT_PRIMARY
			)

	var separator_style: StyleBoxLine = (
		StyleBoxLine.new()
	)

	separator_style.color = (
		ThemeManager.TITLE_BAR_BORDER
	)

	separator_style.thickness = 1

	session_statistics_header_separator.add_theme_stylebox_override(
		"separator",
		separator_style
	)

	session_statistics_close_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	session_statistics_close_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style(
			true
		)
	)

	session_statistics_close_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style(
			true
		)
	)

	session_statistics_close_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	session_statistics_close_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_LIGHT
	)

	session_statistics_close_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)

	session_statistics_footer_close_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	session_statistics_footer_close_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	session_statistics_footer_close_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)

	session_statistics_footer_close_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	session_statistics_footer_close_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_PRIMARY
	)

	session_statistics_footer_close_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)

	session_statistics_footer_close_button.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	
func setup_tools_menu() -> void:
	var popup: PopupMenu = (
		tools_menu_button.get_popup()
	)

	popup.clear()

	popup.add_item(
		"Options",
		TOOLS_MENU_OPTIONS
	)

	popup.add_item(
		"Keyboard Shortcuts",
		TOOLS_MENU_KEYBOARD_SHORTCUTS
	)

	var options_index: int = (
		popup.get_item_index(
			TOOLS_MENU_OPTIONS
		)
	)

	var shortcuts_index: int = (
		popup.get_item_index(
			TOOLS_MENU_KEYBOARD_SHORTCUTS
		)
	)

	popup.set_item_disabled(
		options_index,
		true
	)

	popup.set_item_disabled(
		shortcuts_index,
		true
	)
	
func setup_help_menu() -> void:
	var popup: PopupMenu = (
		help_menu_button.get_popup()
	)

	popup.clear()

	popup.add_item(
		"Restart Tutorial",
		HELP_MENU_RESTART_TUTORIAL
	)

	popup.add_item(
		"How to Play",
		HELP_MENU_HOW_TO_PLAY
	)

	popup.add_separator()

	popup.add_item(
		"About Index 99",
		HELP_MENU_ABOUT
	)

	var how_to_play_index: int = (
		popup.get_item_index(
			HELP_MENU_HOW_TO_PLAY
		)
	)

	var about_index: int = (
		popup.get_item_index(
			HELP_MENU_ABOUT
		)
	)

	popup.set_item_disabled(
		how_to_play_index,
		true
	)

	popup.set_item_disabled(
		about_index,
		true
	)

	if not popup.id_pressed.is_connected(
		_on_help_menu_id_pressed
	):
		popup.id_pressed.connect(
			_on_help_menu_id_pressed
		)
		
func _on_help_menu_id_pressed(
	item_id: int
) -> void:
	match item_id:
		HELP_MENU_RESTART_TUTORIAL:
			TutorialManager.reset_tutorial()
			TutorialManager.start_tutorial()
	
# -------------------------------------------------------------------
# Keyboard Shortcuts
# -------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return

	var key_event: InputEventKey = (
		event as InputEventKey
	)

	if not key_event.pressed:
		return

	if key_event.echo:
		return

	if (
		key_event.ctrl_pressed
		or key_event.alt_pressed
		or key_event.meta_pressed
	):
		return

	if is_text_input_focused():
		return

	if not PAGE_SHORTCUTS.has(
		key_event.keycode
	):
		return

	var page_id: StringName = StringName(
		PAGE_SHORTCUTS[
			key_event.keycode
		]
	)

	_on_tab_selected(
		page_id
	)

	get_viewport().set_input_as_handled()


func is_text_input_focused() -> bool:
	var focused_control: Control = (
		get_viewport().gui_get_focus_owner()
	)

	if focused_control == null:
		return false

	if focused_control is LineEdit:
		return true

	if focused_control is TextEdit:
		return true

	return false


func setup_tabs() -> void:
	tab_buttons = {
		&"dashboard": dashboard_tab,
		&"crawler": crawler_tab,
		&"jobs": jobs_tab,
		&"index": index_tab,
		&"servers": servers_tab,
		&"research": research_tab,
		&"upgrades": upgrades_tab,
		&"activities": activities_tab,
		&"tech": tech_tab
	}

	pages = {
		&"dashboard": dashboard_page,
		&"crawler": crawler_page,
		&"jobs": jobs_page,
		&"index": index_page,
		&"servers": servers_page,
		&"research": research_page,
		&"upgrades": upgrades_page,
		&"activities": activities_page,
		&"tech": tech_tree_page
	}

	for tab_id: StringName in tab_buttons:
		var tab_button := (
			tab_buttons[
				tab_id
			] as TabButton
		)

		if not tab_button.tab_selected.is_connected(
			_on_tab_selected
		):
			tab_button.tab_selected.connect(
				_on_tab_selected
			)
			
# -------------------------------------------------------------------
# Activities Unlock
# -------------------------------------------------------------------

func setup_activities_unlock() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed_for_activities
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed_for_activities
		)

	refresh_activities_tab_unlock_state()
	
func _on_progression_tier_changed_for_activities(
	_new_tier: int
) -> void:
	refresh_activities_tab_unlock_state()
	
func is_activities_unlocked() -> bool:
	return ObjectiveManager.is_progression_tier_unlocked(
		ObjectiveManager.PROGRESSION_TIER_2
	)
	
func refresh_activities_tab_unlock_state() -> void:
	var activities_unlocked: bool = (
		is_activities_unlocked()
	)

	activities_tab.disabled = (
		not activities_unlocked
	)

	if activities_unlocked:
		activities_tab.tooltip_text = (
			"Open Active Operations."
		)

		return

	activities_tab.tooltip_text = (
		"Activities unlock at Progression Tier 2."
	)


func open_page(
	page_id: StringName
) -> void:
	if not pages.has(page_id):
		push_warning(
			"Unknown page ID: %s" % page_id
		)

		return

	if not tab_buttons.has(page_id):
		push_warning(
			"No tab button exists for page ID: %s"
			% page_id
		)

		return

	if (
		page_id == &"activities"
		and not is_activities_unlocked()
	):
		return

	if (
		page_id == &"tech"
		and not is_tech_tree_unlocked()
	):
		return

	current_page_id = page_id

	for stored_page_id: StringName in pages:
		var page := (
			pages[stored_page_id] as Control
		)

		page.visible = (
			stored_page_id == page_id
		)

	for stored_tab_id: StringName in tab_buttons:
		var tab_button := (
			tab_buttons[
				stored_tab_id
			] as TabButton
		)

		tab_button.set_active(
			stored_tab_id == page_id
		)


func _on_tab_selected(
	tab_id: StringName
) -> void:
	open_page(
		tab_id
	)

	TutorialManager.notify_page_opened(
		tab_id
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
	
# -------------------------------------------------------------------
# Tech Tree Unlock
# -------------------------------------------------------------------

func setup_tech_tree_unlock() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed_for_tech_tree
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed_for_tech_tree
		)

	refresh_tech_tree_tab_unlock_state()


func _on_progression_tier_changed_for_tech_tree(
	_new_tier: int
) -> void:
	refresh_tech_tree_tab_unlock_state()


func is_tech_tree_unlocked() -> bool:
	return ObjectiveManager.is_progression_tier_unlocked(
		ObjectiveManager.PROGRESSION_TIER_3
	)


func refresh_tech_tree_tab_unlock_state() -> void:
	var tech_tree_unlocked: bool = (
		is_tech_tree_unlocked()
	)

	tech_tab.disabled = (
		not tech_tree_unlocked
	)

	if tech_tree_unlocked:
		tech_tab.tooltip_text = (
			"Open the Technology Tree."
		)

		return

	tech_tab.tooltip_text = (
		"Tech Tree unlocks at Progression Tier 3."
	)
	
