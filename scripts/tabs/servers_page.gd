extends PanelContainer


# -------------------------------------------------------------------
# Page header
# -------------------------------------------------------------------

@onready var servers_page_status_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServersPageHeader/"
	+ "ServersPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Server Overview
# -------------------------------------------------------------------

@onready var server_overview_panel: SectionPanel = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel"
) as SectionPanel

@onready var server_current_load_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerCurrentLoadRow/ServerCurrentLoadValueLabel"
) as Label

@onready var server_load_progress_bar: ProgressBar = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerLoadProgressBar"
) as ProgressBar

@onready var server_load_generation_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerLoadGenerationRow/"
	+ "ServerLoadGenerationValueLabel"
) as Label

@onready var server_crawler_state_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerCrawlerStateRow/ServerCrawlerStateValueLabel"
) as Label

@onready var server_warning_threshold_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerWarningThresholdRow/"
	+ "ServerWarningThresholdValueLabel"
) as Label

@onready var server_overload_state_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerOverviewLayout/"
	+ "ServerOverloadStateRow/"
	+ "ServerOverloadStateValueLabel"
) as Label


# -------------------------------------------------------------------
# Cooling System
# -------------------------------------------------------------------

@onready var cooling_system_panel: SectionPanel = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "CoolingSystemPanel"
) as SectionPanel

@onready var cooling_status_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "CoolingSystemPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/CoolingSystemLayout/"
	+ "CoolingStatusRow/CoolingStatusValueLabel"
) as Label

@onready var cooling_rate_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "CoolingSystemPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/CoolingSystemLayout/"
	+ "CoolingRateRow/CoolingRateValueLabel"
) as Label

@onready var cooling_recovery_target_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "CoolingSystemPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/CoolingSystemLayout/"
	+ "CoolingRecoveryTargetRow/"
	+ "CoolingRecoveryTargetValueLabel"
) as Label

@onready var cooling_progress_bar: ProgressBar = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "CoolingSystemPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/CoolingSystemLayout/"
	+ "CoolingProgressBar"
) as ProgressBar


# -------------------------------------------------------------------
# Server Capacity
# -------------------------------------------------------------------

@onready var server_capacity_panel: SectionPanel = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerCapacityPanel"
) as SectionPanel

@onready var server_safe_capacity_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerCapacityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerCapacityLayout/"
	+ "ServerSafeCapacityRow/ServerSafeCapacityValueLabel"
) as Label

@onready var server_used_capacity_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerCapacityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerCapacityLayout/"
	+ "ServerUsedCapacityRow/ServerUsedCapacityValueLabel"
) as Label

@onready var server_available_capacity_value_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerCapacityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerCapacityLayout/"
	+ "ServerAvailableCapacityRow/"
	+ "ServerAvailableCapacityValueLabel"
) as Label

@onready var server_capacity_progress_bar: ProgressBar = get_node(
	"ServersMargin/ServersPageLayout/ServerStatusRow/"
	+ "ServerCapacityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerCapacityLayout/"
	+ "ServerCapacityProgressBar"
) as ProgressBar


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	configure_progress_bars()
	connect_game_state_signals()
	refresh_server_page()


func configure_progress_bars() -> void:
	server_load_progress_bar.min_value = 0.0
	server_load_progress_bar.max_value = 100.0
	server_load_progress_bar.step = 1.0
	server_load_progress_bar.show_percentage = false

	cooling_progress_bar.min_value = 0.0
	cooling_progress_bar.max_value = 100.0
	cooling_progress_bar.step = 1.0
	cooling_progress_bar.show_percentage = true

	server_capacity_progress_bar.min_value = 0.0
	server_capacity_progress_bar.max_value = 100.0
	server_capacity_progress_bar.step = 1.0
	server_capacity_progress_bar.show_percentage = true


func connect_game_state_signals() -> void:
	if not GameState.server_load_changed.is_connected(
		_on_server_load_changed
	):
		GameState.server_load_changed.connect(
			_on_server_load_changed
		)

	if not GameState.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		GameState.crawler_state_changed.connect(
			_on_crawler_state_changed
		)


func refresh_server_page() -> void:
	server_warning_threshold_value_label.text = (
		format_percentage(
			CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
		)
	)

	server_safe_capacity_value_label.text = (
		format_percentage(
			CrawlerManager.SERVER_LOAD_MAXIMUM
		)
	)

	cooling_rate_value_label.text = (
		"%s / sec"
		% format_percentage(
			CrawlerManager.SERVER_LOAD_COOLING_PER_TICK
		)
	)

	cooling_recovery_target_value_label.text = (
		"Below %s"
		% format_percentage(
			CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
		)
	)

	_on_server_load_changed(
		GameState.server_load
	)

	_on_crawler_state_changed(
		GameState.crawler_running
	)
	
# -------------------------------------------------------------------
# Live GameState updates
# -------------------------------------------------------------------

func _on_server_load_changed(
	new_value: float
) -> void:
	var safe_load: float = clampf(
		new_value,
		0.0,
		100.0
	)

	var available_capacity: float = maxf(
		100.0 - safe_load,
		0.0
	)

	var cooling_readiness: float = available_capacity

	server_current_load_value_label.text = (
		format_percentage(safe_load)
	)

	server_used_capacity_value_label.text = (
		format_percentage(safe_load)
	)

	server_available_capacity_value_label.text = (
		format_percentage(available_capacity)
	)

	server_load_progress_bar.value = safe_load
	server_capacity_progress_bar.value = safe_load
	cooling_progress_bar.value = cooling_readiness

	apply_server_load_text_color(safe_load)
	update_server_page_status()
	
func _on_crawler_state_changed(
	_is_running: bool
) -> void:
	server_crawler_state_value_label.text = (
		get_crawler_state_text()
	)

	update_load_generation_display()
	update_server_page_status()
	
func get_crawler_state_text() -> String:
	if CrawlerManager.paused_for_overload:
		return "Auto-Paused"

	if GameState.crawler_running:
		return "Running"

	if CrawlerManager.current_job_pages > 0:
		return "Paused"

	return "Offline"
	
func update_load_generation_display() -> void:
	if GameState.crawler_running:
		server_load_generation_value_label.text = (
			"+%s / sec"
			% format_percentage(
				CrawlerManager.SERVER_LOAD_GAIN_PER_TICK
			)
		)
	else:
		server_load_generation_value_label.text = (
			"0% / sec"
		)
		
# -------------------------------------------------------------------
# Server status
# -------------------------------------------------------------------

func update_server_page_status() -> void:
	var server_load: float = GameState.server_load

	update_overload_display(server_load)
	update_cooling_display(server_load)
	update_overview_display(server_load)
	update_capacity_display(server_load)
	update_page_header_display(server_load)
	
func update_overload_display(
	server_load: float
) -> void:
	if (
		CrawlerManager.paused_for_overload
		or server_load >= 100.0
	):
		server_overload_state_value_label.text = (
			"Overloaded"
		)

		server_overload_state_value_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

	elif (
		server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		server_overload_state_value_label.text = (
			"Warning"
		)

		server_overload_state_value_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

	else:
		server_overload_state_value_label.text = "Clear"

		server_overload_state_value_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)
		
func update_cooling_display(
	server_load: float
) -> void:
	if GameState.crawler_running:
		cooling_status_value_label.text = "Standby"

		cooling_system_panel.set_status(
			"STANDBY",
			ThemeManager.TEXT_DISABLED
		)

	elif server_load > 0.0:
		cooling_status_value_label.text = "Cooling"

		cooling_system_panel.set_status(
			"COOLING",
			ThemeManager.STATUS_INFORMATION
		)

	else:
		cooling_status_value_label.text = "Idle"

		cooling_system_panel.set_status(
			"IDLE",
			ThemeManager.TEXT_DISABLED
		)
		
func update_overview_display(
	server_load: float
) -> void:
	if (
		CrawlerManager.paused_for_overload
		or server_load >= 100.0
	):
		server_overview_panel.set_status(
			"CRITICAL",
			ThemeManager.STATUS_ERROR
		)

	elif (
		server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		server_overview_panel.set_status(
			"WARNING",
			ThemeManager.STATUS_WARNING
		)

	elif GameState.crawler_running:
		server_overview_panel.set_status(
			"ACTIVE",
			ThemeManager.STATUS_SUCCESS
		)

	else:
		server_overview_panel.set_status(
			"NORMAL",
			ThemeManager.STATUS_INFORMATION
		)
		
func update_capacity_display(
	server_load: float
) -> void:
	if server_load >= 100.0:
		server_capacity_panel.set_status(
			"FULL",
			ThemeManager.STATUS_ERROR
		)

	elif (
		server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		server_capacity_panel.set_status(
			"LIMITED",
			ThemeManager.STATUS_WARNING
		)

	else:
		server_capacity_panel.set_status(
			"AVAILABLE",
			ThemeManager.STATUS_INFORMATION
		)
		
func update_page_header_display(
	server_load: float
) -> void:
	if (
		CrawlerManager.paused_for_overload
		or server_load >= 100.0
	):
		servers_page_status_label.text = (
			"SYSTEM OVERLOADED"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

	elif (
		server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		servers_page_status_label.text = (
			"HIGH LOAD WARNING"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

	elif (
		not GameState.crawler_running
		and server_load > 0.0
	):
		servers_page_status_label.text = (
			"SYSTEM COOLING"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_INFORMATION
		)

	elif GameState.crawler_running:
		servers_page_status_label.text = (
			"SYSTEM ACTIVE"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

	else:
		servers_page_status_label.text = (
			"SYSTEM STABLE"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)
		
func apply_server_load_text_color(
	server_load: float
) -> void:
	var load_color: Color = get_server_load_color(
		server_load
	)

	server_current_load_value_label.add_theme_color_override(
		"font_color",
		load_color
	)

	server_used_capacity_value_label.add_theme_color_override(
		"font_color",
		load_color
	)


func get_server_load_color(
	server_load: float
) -> Color:
	if server_load >= 100.0:
		return ThemeManager.STATUS_ERROR

	if (
		server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		return ThemeManager.STATUS_WARNING

	return ThemeManager.STATUS_INFORMATION
	
# -------------------------------------------------------------------
# Formatting
# -------------------------------------------------------------------

func format_percentage(
	value: float
) -> String:
	return "%d%%" % roundi(
		clampf(value, 0.0, 100.0)
	)
