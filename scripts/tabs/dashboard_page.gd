extends PanelContainer


const OBJECTIVE_TARGET: int = 100


# -------------------------------------------------------------------
# Traffic Overview
# -------------------------------------------------------------------

@onready var revenue_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "RevenueMetricPanel/RevenueMetricLayout/"
	+ "RevenueValueLabel"
) as Label

@onready var active_users_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "ActiveUsersMetricPanel/ActiveUsersMetricLayout/"
	+ "ActiveUsersValueLabel"
) as Label

@onready var indexed_pages_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "IndexedPagesMetricPanel/IndexedPagesMetricLayout/"
	+ "IndexedPagesValueLabel"
) as Label


# -------------------------------------------------------------------
# Crawler Overview
# -------------------------------------------------------------------

@onready var crawler_overview: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview"
) as SectionPanel

@onready var crawler_status_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerOverviewLayout/CrawlerStatusRow/"
	+ "CrawlerStatusValueLabel"
) as Label

@onready var crawler_rate_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerOverviewLayout/CrawlerRateRow/"
	+ "CrawlerRateValueLabel"
) as Label


# -------------------------------------------------------------------
# Server Overview
# -------------------------------------------------------------------

@onready var server_overview: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview"
) as SectionPanel

@onready var server_load_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerLoadRow/"
	+ "ServerLoadValueLabel"
) as Label

@onready var server_load_progress: ProgressBar = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerLoadProgress"
) as ProgressBar

@onready var server_health_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerHealthRow/"
	+ "ServerHealthValueLabel"
) as Label


# -------------------------------------------------------------------
# Current Objective
# -------------------------------------------------------------------

@onready var current_objective_panel: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel"
) as SectionPanel

@onready var objective_number_label: Label = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveNumberLabel"
) as Label

@onready var objective_title_label: Label = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveTitleLabel"
) as Label

@onready var objective_description_label: Label = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveDescriptionLabel"
) as Label

@onready var objective_progress_bar: ProgressBar = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveProgressBar"
) as ProgressBar

@onready var objective_progress_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveProgressValueLabel"
) as Label

@onready var objective_reward_label: Label = get_node(
	"DashboardMargin/DashboardLayout/DashboardColumns/"
	+ "RightColumn/CurrentObjectivePanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/ObjectiveRewardLabel"
) as Label


func _ready() -> void:
	setup_objective()
	connect_game_state_signals()
	refresh_dashboard()
	
	


# -------------------------------------------------------------------
# Objective setup
# -------------------------------------------------------------------

func setup_objective() -> void:
	objective_number_label.text = "OBJECTIVE 01"
	objective_title_label.text = "Index 100 Pages"

	objective_description_label.text = (
		"Start the crawler and build the first searchable "
		+ "collection of public web pages."
	)

	objective_reward_label.text = "Reward: +0.5 Reputation"

	objective_progress_bar.min_value = 0.0
	objective_progress_bar.max_value = float(OBJECTIVE_TARGET)
	objective_progress_bar.step = 1.0
	objective_progress_bar.show_percentage = false


# -------------------------------------------------------------------
# GameState signal connections
# -------------------------------------------------------------------

func connect_game_state_signals() -> void:
	GameState.revenue_changed.connect(
		_on_revenue_changed
	)

	GameState.active_users_changed.connect(
		_on_active_users_changed
	)

	GameState.indexed_pages_changed.connect(
		_on_indexed_pages_changed
	)

	GameState.server_load_changed.connect(
		_on_server_load_changed
	)

	GameState.crawler_state_changed.connect(
		_on_crawler_state_changed
	)

	GameState.crawler_rate_changed.connect(
		_on_crawler_rate_changed
	)


# -------------------------------------------------------------------
# Initial Dashboard values
# -------------------------------------------------------------------

func refresh_dashboard() -> void:
	_on_revenue_changed(GameState.revenue)
	_on_active_users_changed(GameState.active_users)
	_on_indexed_pages_changed(GameState.indexed_pages)
	_on_server_load_changed(GameState.server_load)

	_on_crawler_state_changed(
		GameState.crawler_running
	)

	_on_crawler_rate_changed(
		GameState.crawler_rate
	)


# -------------------------------------------------------------------
# Resource updates
# -------------------------------------------------------------------

func _on_revenue_changed(new_value: float) -> void:
	revenue_value_label.text = format_money(new_value)


func _on_active_users_changed(new_value: int) -> void:
	active_users_value_label.text = format_whole_number(
		new_value
	)


func _on_indexed_pages_changed(new_value: int) -> void:
	indexed_pages_value_label.text = format_whole_number(
		new_value
	)

	update_objective(new_value)


# -------------------------------------------------------------------
# Crawler updates
# -------------------------------------------------------------------

func _on_crawler_state_changed(is_running: bool) -> void:
	if is_running:
		crawler_status_value_label.text = "Running"

		crawler_overview.set_status(
			"RUNNING",
			ThemeManager.STATUS_SUCCESS
		)
	else:
		crawler_status_value_label.text = "Offline"

		crawler_overview.set_status(
			"OFFLINE",
			ThemeManager.TEXT_DISABLED
		)


func _on_crawler_rate_changed(new_value: float) -> void:
	crawler_rate_value_label.text = format_crawler_rate(
		new_value
	)


# -------------------------------------------------------------------
# Server updates
# -------------------------------------------------------------------

func _on_server_load_changed(new_value: float) -> void:
	var safe_load: float = clampf(
		new_value,
		0.0,
		100.0
	)

	server_load_value_label.text = format_percentage(
		safe_load
	)

	server_load_progress.value = safe_load

	if safe_load >= 100.0:
		server_health_value_label.text = "Critical"

		server_overview.set_status(
			"CRITICAL",
			ThemeManager.STATUS_ERROR
		)

	elif safe_load >= 90.0:
		server_health_value_label.text = "Warning"

		server_overview.set_status(
			"WARNING",
			ThemeManager.STATUS_WARNING
		)

	else:
		server_health_value_label.text = "Normal"

		server_overview.set_status(
			"NORMAL",
			ThemeManager.ACCENT_BLUE
		)


# -------------------------------------------------------------------
# Objective updates
# -------------------------------------------------------------------

func update_objective(indexed_page_count: int) -> void:
	var safe_page_count: int = maxi(
		indexed_page_count,
		0
	)

	var displayed_progress: int = mini(
		safe_page_count,
		OBJECTIVE_TARGET
	)

	objective_progress_bar.value = float(
		displayed_progress
	)

	objective_progress_value_label.text = (
		"%s / %s pages"
		% [
			format_whole_number(displayed_progress),
			format_whole_number(OBJECTIVE_TARGET)
		]
	)

	if safe_page_count >= OBJECTIVE_TARGET:
		current_objective_panel.set_status(
			"COMPLETE",
			ThemeManager.STATUS_SUCCESS
		)
	else:
		current_objective_panel.set_status(
			"ACTIVE",
			ThemeManager.STATUS_WARNING
		)


# -------------------------------------------------------------------
# Formatting
# -------------------------------------------------------------------

func format_money(value: float) -> String:
	var safe_value: float = maxf(value, 0.0)
	var total_cents: int = roundi(safe_value * 100.0)

	var whole_dollars: int = total_cents / 100
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
		var split_index: int = number_text.length() - 3

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
	return "%d%%" % roundi(
		clampf(value, 0.0, 100.0)
	)


func format_crawler_rate(value: float) -> String:
	var safe_value: float = maxf(value, 0.0)
	var rounded_value: int = roundi(safe_value)

	if is_equal_approx(
		safe_value,
		float(rounded_value)
	):
		if rounded_value == 1:
			return "1 page/sec"

		return "%d pages/sec" % rounded_value

	return "%.2f pages/sec" % safe_value
