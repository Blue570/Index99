extends PanelContainer


# -------------------------------------------------------------------
# Page header
# -------------------------------------------------------------------

@onready var index_page_status_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexPageHeader/"
	+ "IndexPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Index Overview
# -------------------------------------------------------------------

@onready var index_overview_panel: SectionPanel = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel"
) as SectionPanel

@onready var index_total_pages_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexTotalPagesRow/IndexTotalPagesValueLabel"
) as Label

@onready var index_current_job_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexCurrentJobRow/IndexCurrentJobValueLabel"
) as Label

@onready var index_crawler_rate_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexCrawlerRateRow/IndexCrawlerRateValueLabel"
) as Label

@onready var index_active_users_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexActiveUsersRow/IndexActiveUsersValueLabel"
) as Label

@onready var index_reputation_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexReputationRow/IndexReputationValueLabel"
) as Label

@onready var index_last_update_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexOverviewPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexOverviewLayout/"
	+ "IndexLastUpdateRow/IndexLastUpdateValueLabel"
) as Label


# -------------------------------------------------------------------
# Index Health
# -------------------------------------------------------------------

@onready var index_health_panel: SectionPanel = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexHealthPanel"
) as SectionPanel

@onready var index_status_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexHealthPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexHealthLayout/"
	+ "IndexStatusRow/IndexStatusValueLabel"
) as Label

@onready var index_crawler_status_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexHealthPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexHealthLayout/"
	+ "IndexCrawlerStatusRow/IndexCrawlerStatusValueLabel"
) as Label

@onready var index_server_load_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexHealthPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexHealthLayout/"
	+ "IndexServerLoadRow/IndexServerLoadValueLabel"
) as Label

@onready var index_freshness_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexOverviewRow/"
	+ "IndexHealthPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexHealthLayout/"
	+ "IndexFreshnessRow/IndexFreshnessValueLabel"
) as Label


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_game_state_signals()
	connect_crawler_manager_signals()
	refresh_index_page()


func connect_game_state_signals() -> void:
	if not GameState.indexed_pages_changed.is_connected(
		_on_indexed_pages_changed
	):
		GameState.indexed_pages_changed.connect(
			_on_indexed_pages_changed
		)

	if not GameState.active_users_changed.is_connected(
		_on_active_users_changed
	):
		GameState.active_users_changed.connect(
			_on_active_users_changed
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

	if not GameState.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		GameState.crawler_state_changed.connect(
			_on_crawler_state_changed
		)

	if not GameState.crawler_rate_changed.is_connected(
		_on_crawler_rate_changed
	):
		GameState.crawler_rate_changed.connect(
			_on_crawler_rate_changed
		)


func connect_crawler_manager_signals() -> void:
	if not CrawlerManager.crawler_progress_changed.is_connected(
		_on_crawler_progress_changed
	):
		CrawlerManager.crawler_progress_changed.connect(
			_on_crawler_progress_changed
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed
		)


# -------------------------------------------------------------------
# Initial refresh
# -------------------------------------------------------------------

func refresh_index_page() -> void:
	_on_indexed_pages_changed(
		GameState.indexed_pages
	)

	_on_active_users_changed(
		GameState.active_users
	)

	_on_reputation_changed(
		GameState.reputation
	)

	_on_server_load_changed(
		GameState.server_load
	)

	_on_crawler_rate_changed(
		GameState.crawler_rate
	)

	_on_crawler_progress_changed(
		CrawlerManager.current_job_pages,
		CrawlerManager.CURRENT_JOB_TARGET_PAGES,
		CrawlerManager.get_progress_percent()
	)

	_on_crawler_state_changed(
		GameState.crawler_running
	)

	index_last_update_value_label.text = (
		"No activity yet"
	)


# -------------------------------------------------------------------
# GameState callbacks
# -------------------------------------------------------------------

func _on_indexed_pages_changed(
	new_value: int
) -> void:
	index_total_pages_value_label.text = (
		format_whole_number(new_value)
	)

	index_overview_panel.set_status(
		"%s PAGES" % format_whole_number(new_value),
		get_overview_status_color(new_value)
	)

	update_index_status()


func _on_active_users_changed(
	new_value: int
) -> void:
	index_active_users_value_label.text = (
		format_whole_number(new_value)
	)


func _on_reputation_changed(
	new_value: float
) -> void:
	index_reputation_value_label.text = (
		"%.1f" % new_value
	)


func _on_server_load_changed(
	new_value: float
) -> void:
	index_server_load_value_label.text = (
		format_percentage(new_value)
	)

	update_index_status()


func _on_crawler_state_changed(
	is_running: bool
) -> void:
	if CrawlerManager.paused_for_overload:
		index_crawler_status_value_label.text = (
			"Auto-Paused"
		)

	elif is_running:
		index_crawler_status_value_label.text = (
			"Running"
		)

	elif CrawlerManager.current_job_pages > 0:
		index_crawler_status_value_label.text = (
			"Paused"
		)

	else:
		index_crawler_status_value_label.text = (
			"Offline"
		)

	update_index_status()


func _on_crawler_rate_changed(
	new_value: float
) -> void:
	index_crawler_rate_value_label.text = (
		format_crawler_rate(new_value)
	)


# -------------------------------------------------------------------
# CrawlerManager callbacks
# -------------------------------------------------------------------

func _on_crawler_progress_changed(
	pages_processed: int,
	target_pages: int,
	_progress_percent: float
) -> void:
	index_current_job_value_label.text = (
		"%s / %s pages"
		% [
			format_whole_number(pages_processed),
			format_whole_number(target_pages)
		]
	)

	update_index_status()


func _on_crawl_job_completed() -> void:
	_on_crawler_progress_changed(
		CrawlerManager.current_job_pages,
		CrawlerManager.CURRENT_JOB_TARGET_PAGES,
		CrawlerManager.get_progress_percent()
	)

	update_index_status()


# -------------------------------------------------------------------
# Index status
# -------------------------------------------------------------------

func update_index_status() -> void:
	if CrawlerManager.paused_for_overload:
		show_warning_status()
		return

	if GameState.server_load >= 90.0:
		show_warning_status()
		return

	if GameState.crawler_running:
		show_updating_status()
		return

	if GameState.indexed_pages > 0:
		show_healthy_status()
		return

	show_idle_status()


func show_idle_status() -> void:
	index_page_status_label.text = "INDEX IDLE"

	index_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	index_status_value_label.text = "Idle"
	index_freshness_value_label.text = "No data"

	index_health_panel.set_status(
		"IDLE",
		ThemeManager.TEXT_DISABLED
	)


func show_updating_status() -> void:
	index_page_status_label.text = "INDEX UPDATING"

	index_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	index_status_value_label.text = "Updating"
	index_freshness_value_label.text = "Live"

	index_health_panel.set_status(
		"UPDATING",
		ThemeManager.STATUS_SUCCESS
	)


func show_healthy_status() -> void:
	index_page_status_label.text = "INDEX HEALTHY"

	index_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	index_status_value_label.text = "Healthy"
	index_freshness_value_label.text = "Paused"

	index_health_panel.set_status(
		"HEALTHY",
		ThemeManager.STATUS_INFORMATION
	)


func show_warning_status() -> void:
	index_page_status_label.text = "INDEX WARNING"

	index_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	index_status_value_label.text = "Warning"

	if CrawlerManager.paused_for_overload:
		index_freshness_value_label.text = "Cooling"
	else:
		index_freshness_value_label.text = "High Load"

	index_health_panel.set_status(
		"WARNING",
		ThemeManager.STATUS_WARNING
	)


func get_overview_status_color(
	indexed_page_count: int
) -> Color:
	if indexed_page_count <= 0:
		return ThemeManager.TEXT_DISABLED

	return ThemeManager.STATUS_INFORMATION


# -------------------------------------------------------------------
# Formatting
# -------------------------------------------------------------------

func format_whole_number(
	value: int
) -> String:
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


func format_percentage(
	value: float
) -> String:
	return "%d%%" % roundi(
		clampf(value, 0.0, 100.0)
	)


func format_crawler_rate(
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
		if rounded_value == 1:
			return "1 page/sec"

		return "%d pages/sec" % rounded_value

	return "%.1f pages/sec" % safe_value
