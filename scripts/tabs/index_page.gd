extends PanelContainer

const MAX_INDEX_ACTIVITY_ENTRIES: int = 5

var index_activity_history: Array[Dictionary] = []

const CATEGORY_TECHNOLOGY: StringName = &"technology"
const CATEGORY_BUSINESS: StringName = &"business"
const CATEGORY_ENTERTAINMENT: StringName = &"entertainment"
const CATEGORY_GENERAL: StringName = &"general"

const CATEGORY_ORDER: Array[StringName] = [
	CATEGORY_TECHNOLOGY,
	CATEGORY_BUSINESS,
	CATEGORY_ENTERTAINMENT,
	CATEGORY_GENERAL
]

var category_page_counts: Dictionary = {
	CATEGORY_TECHNOLOGY: 0,
	CATEGORY_BUSINESS: 0,
	CATEGORY_ENTERTAINMENT: 0,
	CATEGORY_GENERAL: 0
}

var next_category_index: int = 0


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
# Recent Index Activity
# -------------------------------------------------------------------

@onready var index_activity_panel: SectionPanel = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexActivityPanel"
) as SectionPanel

@onready var index_activity_entries: VBoxContainer = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexActivityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexActivityLayout/"
	+ "IndexActivityEntries"
) as VBoxContainer

@onready var index_activity_empty_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexActivityPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexActivityLayout/"
	+ "IndexActivityEntries/IndexActivityEmptyLabel"
) as Label

# -------------------------------------------------------------------
# Content Categories
# -------------------------------------------------------------------

@onready var index_categories_panel: SectionPanel = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexCategoriesPanel"
) as SectionPanel

@onready var technology_category_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexCategoriesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexCategoriesLayout/"
	+ "TechnologyCategoryRow/"
	+ "TechnologyCategoryValueLabel"
) as Label

@onready var business_category_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexCategoriesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexCategoriesLayout/"
	+ "BusinessCategoryRow/"
	+ "BusinessCategoryValueLabel"
) as Label

@onready var entertainment_category_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexCategoriesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexCategoriesLayout/"
	+ "EntertainmentCategoryRow/"
	+ "EntertainmentCategoryValueLabel"
) as Label

@onready var general_category_value_label: Label = get_node(
	"IndexMargin/IndexPageLayout/IndexDetailsRow/"
	+ "IndexCategoriesPanel/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/IndexCategoriesLayout/"
	+ "GeneralCategoryRow/"
	+ "GeneralCategoryValueLabel"
) as Label


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_game_state_signals()
	connect_crawler_manager_signals()
	
	initialize_content_categories()
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
		
func initialize_content_categories() -> void:
	reset_content_categories()

	if GameState.indexed_pages > 0:
		distribute_pages_to_categories(
			GameState.indexed_pages
		)

	refresh_content_category_display()
	
func reset_content_categories() -> void:
	category_page_counts[CATEGORY_TECHNOLOGY] = 0
	category_page_counts[CATEGORY_BUSINESS] = 0
	category_page_counts[CATEGORY_ENTERTAINMENT] = 0
	category_page_counts[CATEGORY_GENERAL] = 0

	next_category_index = 0
	
func distribute_pages_to_categories(
	pages_added: int
) -> void:
	if pages_added <= 0:
		return

	for _page_number in range(pages_added):
		var category_id: StringName = (
			CATEGORY_ORDER[next_category_index]
		)

		var current_count: int = int(
			category_page_counts.get(
				category_id,
				0
			)
		)

		category_page_counts[category_id] = (
			current_count + 1
		)

		next_category_index += 1

		if next_category_index >= CATEGORY_ORDER.size():
			next_category_index = 0


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
	if not CrawlerManager.crawler_tick_completed.is_connected(
		_on_crawler_tick_completed
	):
		CrawlerManager.crawler_tick_completed.connect(
			_on_crawler_tick_completed
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

	if index_activity_history.is_empty():
		index_last_update_value_label.text = (
			"No activity yet"
		)
	else:
		var newest_entry: Dictionary = (
			index_activity_history[0]
		)

		index_last_update_value_label.text = str(
			newest_entry.get(
				"time_text",
				"No activity yet"
			)
		)

	refresh_index_activity_display()


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
	
func _on_crawler_tick_completed(
	pages_added: int,
	_revenue_added: float,
	_active_users_added: int
) -> void:
	if pages_added <= 0:
		return
		
	distribute_pages_to_categories(pages_added)
	refresh_content_category_display()

	var time_text: String = get_current_time_text()

	var activity_entry: Dictionary = {
		"time_text": time_text,
		"pages_added": pages_added,
		"crawler_rate": GameState.crawler_rate,
		"server_load": GameState.server_load
	}

	index_activity_history.push_front(
		activity_entry
	)

	while (
		index_activity_history.size()
		> MAX_INDEX_ACTIVITY_ENTRIES
	):
		index_activity_history.pop_back()

	index_last_update_value_label.text = time_text

	refresh_index_activity_display()
	
func get_current_time_text() -> String:
	var current_time: Dictionary = (
		Time.get_time_dict_from_system()
	)

	var hour_24: int = int(
		current_time.get("hour", 0)
	)

	var minute: int = int(
		current_time.get("minute", 0)
	)

	var period_text: String = (
		"AM"
		if hour_24 < 12
		else "PM"
	)

	var hour_12: int = hour_24 % 12

	if hour_12 == 0:
		hour_12 = 12

	return "%d:%02d %s" % [
		hour_12,
		minute,
		period_text
	]
	
func refresh_index_activity_display() -> void:
	clear_generated_activity_rows()

	if index_activity_history.is_empty():
		index_activity_empty_label.visible = true

		index_activity_panel.set_status(
			"EMPTY",
			ThemeManager.TEXT_DISABLED
		)

		return

	index_activity_empty_label.visible = false

	for activity_index in range(
		index_activity_history.size()
	):
		var activity_entry: Dictionary = (
			index_activity_history[activity_index]
		)

		var activity_row: HBoxContainer = (
			create_index_activity_row(
				activity_entry,
				activity_index
			)
		)

		index_activity_entries.add_child(
			activity_row
		)

	var entry_count: int = (
		index_activity_history.size()
	)

	var status_text: String

	if entry_count == 1:
		status_text = "1 ENTRY"
	else:
		status_text = "%d ENTRIES" % entry_count

	index_activity_panel.set_status(
		status_text,
		ThemeManager.STATUS_INFORMATION
	)
	
func clear_generated_activity_rows() -> void:
	for child in index_activity_entries.get_children():
		if child == index_activity_empty_label:
			continue

		index_activity_entries.remove_child(
			child
		)

		child.queue_free()
		
func create_index_activity_row(
	activity_entry: Dictionary,
	activity_index: int
) -> HBoxContainer:
	var activity_row := HBoxContainer.new()

	activity_row.name = (
		"IndexActivityRow_%d"
		% (activity_index + 1)
	)

	activity_row.custom_minimum_size.y = 22.0

	activity_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	activity_row.add_theme_constant_override(
		"separation",
		8
	)

	var time_text: String = str(
		activity_entry.get(
			"time_text",
			"--:--"
		)
	)

	var pages_added: int = int(
		activity_entry.get(
			"pages_added",
			0
		)
	)

	var crawler_rate: float = float(
		activity_entry.get(
			"crawler_rate",
			0.0
		)
	)

	var server_load: float = float(
		activity_entry.get(
			"server_load",
			0.0
		)
	)

	var pages_text: String

	if pages_added == 1:
		pages_text = "+1 page"
	else:
		pages_text = "+%d pages" % pages_added

	var time_label: Label = create_activity_label(
		time_text,
		90.0,
		false,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	var pages_label: Label = create_activity_label(
		pages_text,
		0.0,
		true,
		HORIZONTAL_ALIGNMENT_LEFT
	)

	var rate_label: Label = create_activity_label(
		format_crawler_rate(crawler_rate),
		110.0,
		false,
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	var load_label: Label = create_activity_label(
		format_percentage(server_load),
		80.0,
		false,
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	activity_row.add_child(time_label)
	activity_row.add_child(pages_label)
	activity_row.add_child(rate_label)
	activity_row.add_child(load_label)

	return activity_row
	
func create_activity_label(
	label_text: String,
	minimum_width: float,
	should_expand: bool,
	text_alignment: HorizontalAlignment
) -> Label:
	var activity_label := Label.new()

	activity_label.text = label_text
	activity_label.custom_minimum_size.x = minimum_width

	activity_label.vertical_alignment = (
		VERTICAL_ALIGNMENT_CENTER
	)

	activity_label.horizontal_alignment = (
		text_alignment
	)

	activity_label.size_flags_vertical = (
		Control.SIZE_FILL
	)

	if should_expand:
		activity_label.size_flags_horizontal = (
			Control.SIZE_EXPAND_FILL
		)
	else:
		activity_label.size_flags_horizontal = (
			Control.SIZE_FILL
		)

	activity_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	activity_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	return activity_label
	
func refresh_content_category_display() -> void:
	var total_pages: int = get_total_category_pages()

	var technology_pages: int = int(
		category_page_counts.get(
			CATEGORY_TECHNOLOGY,
			0
		)
	)

	var business_pages: int = int(
		category_page_counts.get(
			CATEGORY_BUSINESS,
			0
		)
	)

	var entertainment_pages: int = int(
		category_page_counts.get(
			CATEGORY_ENTERTAINMENT,
			0
		)
	)

	var general_pages: int = int(
		category_page_counts.get(
			CATEGORY_GENERAL,
			0
		)
	)

	technology_category_value_label.text = (
		format_category_value(
			technology_pages,
			total_pages
		)
	)

	business_category_value_label.text = (
		format_category_value(
			business_pages,
			total_pages
		)
	)

	entertainment_category_value_label.text = (
		format_category_value(
			entertainment_pages,
			total_pages
		)
	)

	general_category_value_label.text = (
		format_category_value(
			general_pages,
			total_pages
		)
	)

	index_categories_panel.set_status(
		get_category_panel_status_text(total_pages),
		get_category_panel_status_color(total_pages)
	)
	
func get_total_category_pages() -> int:
	return (
		int(
			category_page_counts.get(
				CATEGORY_TECHNOLOGY,
				0
			)
		)
		+ int(
			category_page_counts.get(
				CATEGORY_BUSINESS,
				0
			)
		)
		+ int(
			category_page_counts.get(
				CATEGORY_ENTERTAINMENT,
				0
			)
		)
		+ int(
			category_page_counts.get(
				CATEGORY_GENERAL,
				0
			)
		)
	)
	
func format_category_value(
	category_pages: int,
	total_pages: int
) -> String:
	var percentage: float = 0.0

	if total_pages > 0:
		percentage = (
			float(category_pages)
			/ float(total_pages)
			* 100.0
		)

	var page_word: String = (
		"page"
		if category_pages == 1
		else "pages"
	)

	return "%s %s - %d%%" % [
		format_whole_number(category_pages),
		page_word,
		roundi(percentage)
	]
	
func get_category_panel_status_text(
	total_pages: int
) -> String:
	if total_pages == 1:
		return "1 PAGE"

	return "%s PAGES" % format_whole_number(
		total_pages
	)
	
func get_category_panel_status_color(
	total_pages: int
) -> Color:
	if total_pages <= 0:
		return ThemeManager.TEXT_DISABLED

	return ThemeManager.STATUS_INFORMATION


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

	return "%.2f pages/sec" % safe_value
