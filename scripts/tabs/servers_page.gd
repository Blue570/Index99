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
# Server Upgrades
# -------------------------------------------------------------------

@onready var server_upgrades_panel: SectionPanel = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel"
) as SectionPanel


# Improved Cooling

@onready var improved_cooling_level_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "ImprovedCoolingUpgradeRow/"
	+ "ImprovedCoolingUpgradeLevelLabel"
) as Label

@onready var improved_cooling_cost_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "ImprovedCoolingUpgradeRow/"
	+ "ImprovedCoolingUpgradeCostLabel"
) as Label

@onready var improved_cooling_max_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "ImprovedCoolingUpgradeRow/"
	+ "ImprovedCoolingUpgradeMaxLabel"
) as Label

@onready var improved_cooling_description_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "ImprovedCoolingDescriptionLabel"
) as Label

@onready var improved_cooling_purchase_button: Button = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "ImprovedCoolingUpgradeRow/"
	+ "ImprovedCoolingPurchaseButton"
) as Button


# Efficient Crawling

@onready var efficient_crawling_level_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "EfficientCrawlingUpgradeRow/"
	+ "EfficientCrawlingUpgradeLevelLabel"
) as Label

@onready var efficient_crawling_cost_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "EfficientCrawlingUpgradeRow/"
	+ "EfficientCrawlingUpgradeCostLabel"
) as Label

@onready var efficient_crawling_max_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "EfficientCrawlingUpgradeRow/"
	+ "EfficientCrawlingUpgradeMaxLabel"
) as Label

@onready var efficient_crawling_description_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "EfficientCrawlingDescriptionLabel"
) as Label

@onready var efficient_crawling_purchase_button: Button = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "EfficientCrawlingUpgradeRow/"
	+ "EfficientCrawlingPurchaseButton"
) as Button


# Load Buffering

@onready var load_buffering_level_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "LoadBufferingUpgradeRow/"
	+ "LoadBufferingUpgradeLevelLabel"
) as Label

@onready var load_buffering_cost_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "LoadBufferingUpgradeRow/"
	+ "LoadBufferingUpgradeCostLabel"
) as Label

@onready var load_buffering_max_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "LoadBufferingUpgradeRow/"
	+ "LoadBufferingUpgradeMaxLabel"
) as Label

@onready var load_buffering_description_label: Label = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "LoadBufferingDescriptionLabel"
) as Label

@onready var load_buffering_purchase_button: Button = get_node(
	"ServersMargin/ServersPageLayout/ServerManagementRow/"
	+ "ServerUpgradesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/ServerUpgradesLayout/"
	+ "LoadBufferingUpgradeRow/"
	+ "LoadBufferingPurchaseButton"
) as Button


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	configure_progress_bars()

	connect_game_state_signals()
	connect_server_manager_signals()
	connect_upgrade_buttons()

	refresh_server_page()
	refresh_server_upgrades()
	
	connect_progression_signals()


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
		
	if not GameState.revenue_changed.is_connected(
		_on_revenue_changed
	):
		GameState.revenue_changed.connect(
			_on_revenue_changed
		)


func refresh_server_page() -> void:
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	var cooling_rate: float = (
		CrawlerManager.get_effective_cooling_rate()
	)

	server_warning_threshold_value_label.text = (
		format_load_value(warning_threshold)
	)

	server_safe_capacity_value_label.text = (
		format_load_value(maximum_safe_load)
	)

	cooling_rate_value_label.text = (
		"%s / sec"
		% format_load_value(cooling_rate)
	)

	cooling_recovery_target_value_label.text = (
		"Below %s"
		% format_load_value(warning_threshold)
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
	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	var safe_load: float = clampf(
		new_value,
		0.0,
		maximum_safe_load
	)

	var available_capacity: float = maxf(
		maximum_safe_load - safe_load,
		0.0
	)

	var used_capacity_percent: float = (
		CrawlerManager.get_server_load_usage_percent(
			safe_load
		)
	)

	var cooling_readiness: float = maxf(
		100.0 - used_capacity_percent,
		0.0
	)

	server_current_load_value_label.text = (
		format_load_value(safe_load)
	)

	server_used_capacity_value_label.text = (
		format_percentage(
			used_capacity_percent
		)
	)

	server_available_capacity_value_label.text = (
		format_load_value(
			available_capacity
		)
	)

	server_load_progress_bar.value = (
		used_capacity_percent
	)

	server_capacity_progress_bar.value = (
		used_capacity_percent
	)

	cooling_progress_bar.value = (
		cooling_readiness
	)

	apply_server_load_text_color(
		safe_load
	)

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
		var generated_load: float = (
			CrawlerManager
			.get_effective_server_load_generation()
		)

		server_load_generation_value_label.text = (
			"+%s / sec"
			% format_load_value(generated_load)
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
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	if (
		CrawlerManager.paused_for_overload
		or server_load >= maximum_safe_load
	):
		server_overload_state_value_label.text = (
			"Overloaded"
		)

		server_overload_state_value_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

	elif server_load >= warning_threshold:
		server_overload_state_value_label.text = (
			"Warning"
		)

		server_overload_state_value_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

	else:
		server_overload_state_value_label.text = (
			"Clear"
		)

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
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	if (
		CrawlerManager.paused_for_overload
		or server_load >= maximum_safe_load
	):
		server_overview_panel.set_status(
			"CRITICAL",
			ThemeManager.STATUS_ERROR
		)

	elif server_load >= warning_threshold:
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
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	if server_load >= maximum_safe_load:
		server_capacity_panel.set_status(
			"FULL",
			ThemeManager.STATUS_ERROR
		)

	elif server_load >= warning_threshold:
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
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	if (
		CrawlerManager.paused_for_overload
		or server_load >= maximum_safe_load
	):
		servers_page_status_label.text = (
			"SYSTEM OVERLOADED"
		)

		servers_page_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

	elif server_load >= warning_threshold:
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
	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	if server_load >= maximum_safe_load:
		return ThemeManager.STATUS_ERROR

	if server_load >= warning_threshold:
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
	
func format_load_value(
	value: float
) -> String:
	var safe_value: float = maxf(
		value,
		0.0
	)

	var rounded_value: int = roundi(
		safe_value
	)

	if is_equal_approx(
		safe_value,
		float(rounded_value)
	):
		return "%d%%" % rounded_value

	return "%.1f%%" % safe_value
	
func connect_server_manager_signals() -> void:
	if not ServerManager.cooling_speed_level_changed.is_connected(
		_on_cooling_speed_level_changed
	):
		ServerManager.cooling_speed_level_changed.connect(
			_on_cooling_speed_level_changed
		)

	if not ServerManager.crawler_efficiency_level_changed.is_connected(
		_on_crawler_efficiency_level_changed
	):
		ServerManager.crawler_efficiency_level_changed.connect(
			_on_crawler_efficiency_level_changed
		)

	if not ServerManager.maximum_safe_load_level_changed.is_connected(
		_on_maximum_safe_load_level_changed
	):
		ServerManager.maximum_safe_load_level_changed.connect(
			_on_maximum_safe_load_level_changed
		)
		
func connect_upgrade_buttons() -> void:
	if not improved_cooling_purchase_button.pressed.is_connected(
		_on_improved_cooling_purchase_pressed
	):
		improved_cooling_purchase_button.pressed.connect(
			_on_improved_cooling_purchase_pressed
		)

	if not efficient_crawling_purchase_button.pressed.is_connected(
		_on_efficient_crawling_purchase_pressed
	):
		efficient_crawling_purchase_button.pressed.connect(
			_on_efficient_crawling_purchase_pressed
		)

	if not load_buffering_purchase_button.pressed.is_connected(
		_on_load_buffering_purchase_pressed
	):
		load_buffering_purchase_button.pressed.connect(
			_on_load_buffering_purchase_pressed
		)
		
# -------------------------------------------------------------------
# Upgrade callbacks
# -------------------------------------------------------------------

func _on_revenue_changed(
	_new_revenue: float
) -> void:
	refresh_server_upgrades()


func _on_cooling_speed_level_changed(
	_new_level: int
) -> void:
	refresh_server_upgrades()
	refresh_server_page()


func _on_crawler_efficiency_level_changed(
	_new_level: int
) -> void:
	refresh_server_upgrades()
	refresh_server_page()


func _on_maximum_safe_load_level_changed(
	_new_level: int
) -> void:
	refresh_server_upgrades()
	refresh_server_page()
	
func _on_improved_cooling_purchase_pressed() -> void:
	ServerManager.purchase_cooling_speed()
	refresh_server_upgrades()


func _on_efficient_crawling_purchase_pressed() -> void:
	ServerManager.purchase_crawler_efficiency()
	refresh_server_upgrades()


func _on_load_buffering_purchase_pressed() -> void:
	ServerManager.purchase_maximum_safe_load()
	refresh_server_upgrades()
	
# -------------------------------------------------------------------
# Upgrade display
# -------------------------------------------------------------------

func refresh_server_upgrades() -> void:
	refresh_improved_cooling_upgrade()
	refresh_efficient_crawling_upgrade()
	refresh_load_buffering_upgrade()
	refresh_upgrade_panel_status()
	
func refresh_improved_cooling_upgrade() -> void:
	var current_level: int = (
		ServerManager.cooling_speed_level
	)

	var is_maxed: bool = (
		ServerManager.is_cooling_speed_maxed()
	)

	improved_cooling_level_label.text = (
		"Level %d" % current_level
	)

	improved_cooling_max_label.text = (
		"Level %d"
		% ServerManager.MAX_UPGRADE_LEVEL
	)

	# ---------------------------------------------------------------
	# STATE 1 — TRUE MAXIMUM
	# ---------------------------------------------------------------

	if is_maxed:
		improved_cooling_cost_label.text = "—"

		improved_cooling_description_label.text = (
			"Maximum Effect: +%d%% cooling speed per second"
			% roundi(
				current_level
				* ServerManager.COOLING_SPEED_BONUS_PER_LEVEL
			)
		)

		configure_maxed_purchase_button(
			improved_cooling_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 2 — TIER 2 LOCKED
	# ---------------------------------------------------------------

	if not ServerManager.is_next_upgrade_level_unlocked(
		current_level
	):
		improved_cooling_cost_label.text = "—"

		improved_cooling_description_label.text = (
			"Next Effect: Tier 2 Required"
		)

		configure_tier_locked_purchase_button(
			improved_cooling_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 3 — NORMAL PURCHASE
	# ---------------------------------------------------------------

	var upgrade_cost: float = (
		ServerManager.get_cooling_speed_cost()
	)

	var next_level: int = current_level + 1

	improved_cooling_cost_label.text = (
		format_currency(upgrade_cost)
	)

	improved_cooling_description_label.text = (
		"Next Effect: +%d%% cooling/sec "
		+ "(total bonus: +%d%%)"
	) % [
		roundi(
			ServerManager.COOLING_SPEED_BONUS_PER_LEVEL
		),
		roundi(
			next_level
			* ServerManager.COOLING_SPEED_BONUS_PER_LEVEL
		)
	]

	configure_purchase_button(
		improved_cooling_purchase_button,
		upgrade_cost
	)
	
func refresh_efficient_crawling_upgrade() -> void:
	var current_level: int = (
		ServerManager.crawler_efficiency_level
	)

	var is_maxed: bool = (
		ServerManager.is_crawler_efficiency_maxed()
	)

	efficient_crawling_level_label.text = (
		"Level %d" % current_level
	)

	efficient_crawling_max_label.text = (
		"Level %d"
		% ServerManager.MAX_UPGRADE_LEVEL
	)

	# ---------------------------------------------------------------
	# STATE 1 — TRUE MAXIMUM
	# ---------------------------------------------------------------

	if is_maxed:
		efficient_crawling_cost_label.text = "—"

		efficient_crawling_description_label.text = (
			"Maximum Effect: -%.1f%% server load generated per second"
			% (
				current_level
				* ServerManager.CRAWLER_EFFICIENCY_BONUS_PER_LEVEL
			)
		)

		configure_maxed_purchase_button(
			efficient_crawling_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 2 — TIER 2 LOCKED
	# ---------------------------------------------------------------

	if not ServerManager.is_next_upgrade_level_unlocked(
		current_level
	):
		efficient_crawling_cost_label.text = "—"

		efficient_crawling_description_label.text = (
			"Next Effect: Tier 2 Required"
		)

		configure_tier_locked_purchase_button(
			efficient_crawling_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 3 — NORMAL PURCHASE
	# ---------------------------------------------------------------

	var upgrade_cost: float = (
		ServerManager.get_crawler_efficiency_cost()
	)

	var next_level: int = current_level + 1

	efficient_crawling_cost_label.text = (
		format_currency(upgrade_cost)
	)

	efficient_crawling_description_label.text = (
		"Next Effect: -%.1f%% load/sec "
		+ "(total reduction: -%.1f%%)"
	) % [
		ServerManager.CRAWLER_EFFICIENCY_BONUS_PER_LEVEL,
		next_level
		* ServerManager.CRAWLER_EFFICIENCY_BONUS_PER_LEVEL
	]

	configure_purchase_button(
		efficient_crawling_purchase_button,
		upgrade_cost
	)
	
func refresh_load_buffering_upgrade() -> void:
	var current_level: int = (
		ServerManager.maximum_safe_load_level
	)

	var is_maxed: bool = (
		ServerManager.is_maximum_safe_load_maxed()
	)

	load_buffering_level_label.text = (
		"Level %d" % current_level
	)

	load_buffering_max_label.text = (
		"Level %d"
		% ServerManager.MAX_UPGRADE_LEVEL
	)

	# ---------------------------------------------------------------
	# STATE 1 — TRUE MAXIMUM
	# ---------------------------------------------------------------

	if is_maxed:
		load_buffering_cost_label.text = "—"

		load_buffering_description_label.text = (
			"Maximum Effect: +%d%% maximum safe server load"
			% roundi(
				current_level
				* ServerManager.MAXIMUM_SAFE_LOAD_BONUS_PER_LEVEL
			)
		)

		configure_maxed_purchase_button(
			load_buffering_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 2 — TIER 2 LOCKED
	# ---------------------------------------------------------------

	if not ServerManager.is_next_upgrade_level_unlocked(
		current_level
	):
		load_buffering_cost_label.text = "—"

		load_buffering_description_label.text = (
			"Next Effect: Tier 2 Required"
		)

		configure_tier_locked_purchase_button(
			load_buffering_purchase_button
		)

		return

	# ---------------------------------------------------------------
	# STATE 3 — NORMAL PURCHASE
	# ---------------------------------------------------------------

	var upgrade_cost: float = (
		ServerManager.get_maximum_safe_load_cost()
	)

	var next_level: int = current_level + 1

	load_buffering_cost_label.text = (
		format_currency(upgrade_cost)
	)

	load_buffering_description_label.text = (
		"Next Effect: +%d%% safe load "
		+ "(total bonus: +%d%%)"
	) % [
		roundi(
			ServerManager.MAXIMUM_SAFE_LOAD_BONUS_PER_LEVEL
		),
		roundi(
			next_level
			* ServerManager.MAXIMUM_SAFE_LOAD_BONUS_PER_LEVEL
		)
	]

	configure_purchase_button(
		load_buffering_purchase_button,
		upgrade_cost
	)
	
func configure_purchase_button(
	purchase_button: Button,
	upgrade_cost: float
) -> void:
	var can_afford: bool = (
		ServerManager.can_afford_upgrade(
			upgrade_cost
		)
	)

	purchase_button.text = "Purchase"
	purchase_button.disabled = not can_afford

	if can_afford:
		purchase_button.tooltip_text = (
			"Purchase this upgrade for %s."
			% format_currency(upgrade_cost)
		)
	else:
		purchase_button.tooltip_text = (
			"Requires %s. Current revenue: %s."
			% [
				format_currency(upgrade_cost),
				format_currency(GameState.revenue)
			]
		)
		
func configure_tier_locked_purchase_button(
	purchase_button: Button
) -> void:
	purchase_button.text = "TIER 2 LOCKED"
	purchase_button.disabled = true
	purchase_button.tooltip_text = (
		"Complete the initial objectives to unlock "
		+ "Tier 2 server upgrades."
	)		

func configure_maxed_purchase_button(
	purchase_button: Button
) -> void:
	purchase_button.text = "MAX"
	purchase_button.disabled = true
	purchase_button.tooltip_text = (
		"This upgrade has reached its maximum level."
	)
	
func refresh_upgrade_panel_status() -> void:
	var maxed_upgrade_count: int = 0

	if ServerManager.is_cooling_speed_maxed():
		maxed_upgrade_count += 1

	if ServerManager.is_crawler_efficiency_maxed():
		maxed_upgrade_count += 1

	if ServerManager.is_maximum_safe_load_maxed():
		maxed_upgrade_count += 1

	if maxed_upgrade_count >= 3:
		server_upgrades_panel.set_status(
			"ALL MAXED",
			ThemeManager.STATUS_SUCCESS
		)

		return

	var available_upgrade_count: int = (
		3 - maxed_upgrade_count
	)

	server_upgrades_panel.set_status(
		"%d AVAILABLE"
		% available_upgrade_count,
		ThemeManager.STATUS_INFORMATION
	)
	
func format_currency(
	value: float
) -> String:
	return "$%.2f" % maxf(
		value,
		0.0
	)
	
func connect_progression_signals() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)
		
func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	refresh_server_page()
	refresh_server_upgrades()
