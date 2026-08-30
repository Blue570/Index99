extends PanelContainer


# -------------------------------------------------------------------
# Page header
# -------------------------------------------------------------------

@onready var crawler_page_status_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageHeader/"
	+ "CrawlerPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Crawler Control panel
# -------------------------------------------------------------------

@onready var crawler_control_panel: SectionPanel = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel"
) as SectionPanel

@onready var crawler_control_status_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerControlStatusRow/"
	+ "CrawlerControlStatusValueLabel"
) as Label

@onready var crawler_control_rate_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerControlRateRow/"
	+ "CrawlerControlRateValueLabel"
) as Label

@onready var start_crawler_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerButtonsRow/"
	+ "StartCrawlerButton"
) as Button

@onready var pause_crawler_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerButtonsRow/"
	+ "PauseCrawlerButton"
) as Button

@onready var manual_crawl_assist_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/ManualCrawlAssistButton"
) as Button


# -------------------------------------------------------------------
# Current Crawl Job panel
# -------------------------------------------------------------------

@onready var current_crawl_job_panel: SectionPanel = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel"
) as SectionPanel

@onready var current_job_target_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentCrawlJobLayout/CurrentJobTargetRow/"
	+ "CurrentJobTargetValueLabel"
) as Label

@onready var current_job_state_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentCrawlJobLayout/CurrentJobStateRow/"
	+ "CurrentJobStateValueLabel"
) as Label

@onready var current_job_progress_bar: ProgressBar = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentCrawlJobLayout/CurrentJobProgressBar"
) as ProgressBar

@onready var current_job_processed_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentCrawlJobLayout/CurrentJobProcessedRow/"
	+ "CurrentJobProcessedValueLabel"
) as Label

@onready var current_job_remaining_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CurrentCrawlJobPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CurrentCrawlJobLayout/CurrentJobRemainingRow/"
	+ "CurrentJobRemainingValueLabel"
) as Label


# -------------------------------------------------------------------
# Crawler Statistics panel
# -------------------------------------------------------------------

@onready var statistics_indexed_pages_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/CrawlerStatisticsPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerStatisticsLayout/StatisticsIndexedPagesRow/"
	+ "StatisticsIndexedPagesValueLabel"
) as Label

@onready var statistics_crawler_rate_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/CrawlerStatisticsPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerStatisticsLayout/StatisticsCrawlerRateRow/"
	+ "StatisticsCrawlerRateValueLabel"
) as Label

@onready var statistics_active_users_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/CrawlerStatisticsPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerStatisticsLayout/StatisticsActiveUsersRow/"
	+ "StatisticsActiveUsersValueLabel"
) as Label

@onready var statistics_server_load_value_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/CrawlerStatisticsPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerStatisticsLayout/StatisticsServerLoadRow/"
	+ "StatisticsServerLoadValueLabel"
) as Label

@onready var basic_crawl_button: Button = (
	find_child(
		"BasicCrawlButton",
		true,
		false
	) as Button
)

@onready var expanded_crawl_button: Button = (
	find_child(
		"ExpandedCrawlButton",
		true,
		false
	) as Button
)

@onready var deep_crawl_button: Button = (
	find_child(
		"DeepCrawlButton",
		true,
		false
	) as Button
)

@onready var crawl_job_selection_info_label: Label = (
	find_child(
		"CrawlJobSelectionInfoLabel",
		true,
		false
	) as Label
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	setup_progress_bar()
	connect_buttons()
	connect_crawler_signals()
	connect_game_state_signals()
	refresh_crawler_page()
	connect_progression_signals()


func setup_progress_bar() -> void:
	current_job_progress_bar.min_value = 0.0
	current_job_progress_bar.max_value = 100.0
	current_job_progress_bar.step = 1.0
	current_job_progress_bar.show_percentage = true


func connect_buttons() -> void:
	if not start_crawler_button.pressed.is_connected(
		_on_start_crawler_button_pressed
	):
		start_crawler_button.pressed.connect(
			_on_start_crawler_button_pressed
		)

	if not pause_crawler_button.pressed.is_connected(
		_on_pause_crawler_button_pressed
	):
		pause_crawler_button.pressed.connect(
			_on_pause_crawler_button_pressed
		)
		
	if not manual_crawl_assist_button.pressed.is_connected(
		_on_manual_crawl_assist_button_pressed
	):
		manual_crawl_assist_button.pressed.connect(
			_on_manual_crawl_assist_button_pressed
		)
		
	if not basic_crawl_button.pressed.is_connected(
		_on_basic_crawl_button_pressed
	):
		basic_crawl_button.pressed.connect(
			_on_basic_crawl_button_pressed
	)

	if not expanded_crawl_button.pressed.is_connected(
		_on_expanded_crawl_button_pressed
	):
		expanded_crawl_button.pressed.connect(
			_on_expanded_crawl_button_pressed
	)

	if not deep_crawl_button.pressed.is_connected(
		_on_deep_crawl_button_pressed
	):
		deep_crawl_button.pressed.connect(
			_on_deep_crawl_button_pressed
	)
	
func _on_basic_crawl_button_pressed() -> void:
	var selection_changed: bool = (
		CrawlerManager.select_crawl_job(
			CrawlerManager.CRAWL_JOB_BASIC
		)
	)

	if selection_changed:
		refresh_crawler_page()


func _on_expanded_crawl_button_pressed() -> void:
	var selection_changed: bool = (
		CrawlerManager.select_crawl_job(
			CrawlerManager.CRAWL_JOB_EXPANDED
		)
	)

	if selection_changed:
		refresh_crawler_page()


func _on_deep_crawl_button_pressed() -> void:
	var selection_changed: bool = (
		CrawlerManager.select_crawl_job(
			CrawlerManager.CRAWL_JOB_DEEP
		)
	)

	if selection_changed:
		refresh_crawler_page()
		
func refresh_crawl_job_selection() -> void:
	var selected_job_id: StringName = (
		CrawlerManager.get_selected_job_id()
	)

	var current_target: int = (
		CrawlerManager.get_current_job_target_pages()
	)

	var selected_name: String = (
		CrawlerManager.get_selected_job_display_name()
	)

	crawl_job_selection_info_label.text = (
		"Selected: %s | Target: %d pages"
		% [
			selected_name,
			current_target
		]
	)

	refresh_crawl_job_button(
		basic_crawl_button,
		CrawlerManager.CRAWL_JOB_BASIC,
		selected_job_id
	)

	refresh_crawl_job_button(
		expanded_crawl_button,
		CrawlerManager.CRAWL_JOB_EXPANDED,
		selected_job_id
	)

	refresh_crawl_job_button(
		deep_crawl_button,
		CrawlerManager.CRAWL_JOB_DEEP,
		selected_job_id
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
	refresh_crawl_job_selection()
	
func refresh_crawl_job_button(
	button: Button,
	job_id: StringName,
	selected_job_id: StringName
) -> void:
	var unlocked: bool = (
		CrawlerManager.is_crawl_job_unlocked(
			job_id
		)
	)

	var selected: bool = (
		job_id == selected_job_id
	)

	var job_name: String = (
		CrawlerManager.get_job_display_name(
			job_id
		)
	)

	var job_target: int = (
		CrawlerManager.get_job_target_pages(
			job_id
		)
	)

	var selection_locked: bool = (
		GameState.crawler_running
		or (
			CrawlerManager.current_job_pages > 0
			and not CrawlerManager.is_current_job_complete()
		)
	)

	if not unlocked:
		button.text = (
			"%s (%d) - LOCKED"
			% [
				job_name,
				job_target
			]
		)

		button.disabled = true
		return

	if selected:
		button.text = (
			"%s (%d) - SELECTED"
			% [
				job_name,
				job_target
			]
		)

		button.disabled = true
		return

	button.text = (
		"%s (%d)"
		% [
			job_name,
			job_target
		]
	)

	button.disabled = selection_locked


func connect_crawler_signals() -> void:
	if not CrawlerManager.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		CrawlerManager.crawler_state_changed.connect(
			_on_crawler_state_changed
		)

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

	if not GameState.server_load_changed.is_connected(
		_on_server_load_changed
	):
		GameState.server_load_changed.connect(
			_on_server_load_changed
		)

	if not GameState.crawler_rate_changed.is_connected(
		_on_crawler_rate_changed
	):
		GameState.crawler_rate_changed.connect(
			_on_crawler_rate_changed
		)


# -------------------------------------------------------------------
# Initial refresh
# -------------------------------------------------------------------

func refresh_crawler_page() -> void:
	_on_indexed_pages_changed(GameState.indexed_pages)
	_on_active_users_changed(GameState.active_users)
	_on_server_load_changed(GameState.server_load)
	_on_crawler_rate_changed(GameState.crawler_rate)

	update_crawler_progress(
		CrawlerManager.current_job_pages,
		CrawlerManager.get_current_job_target_pages(),
		CrawlerManager.get_progress_percent()
	)

	update_crawler_state(
		GameState.crawler_running
	)
	
	refresh_crawl_job_selection()


# -------------------------------------------------------------------
# Button callbacks
# -------------------------------------------------------------------

func _on_start_crawler_button_pressed() -> void:
	CrawlerManager.start_crawler()


func _on_pause_crawler_button_pressed() -> void:
	CrawlerManager.pause_crawler()
	
func _on_manual_crawl_assist_button_pressed() -> void:
	var assist_used: bool = (
		CrawlerManager.use_manual_crawl_assist()
	)

	if not assist_used:
		refresh_manual_crawl_assist_button()
		
func refresh_manual_crawl_assist_button() -> void:
	var assist_available: bool = (
		CrawlerManager.can_use_manual_crawl_assist()
	)

	manual_crawl_assist_button.disabled = (
		not assist_available
	)

	manual_crawl_assist_button.text = (
		"Manual Crawl Assist"
	)

	if assist_available:
		manual_crawl_assist_button.tooltip_text = (
			"Click repeatedly to add +%.2f page work. "
			+ "Each click also adds +%.2f server load."
		) % [
			CrawlerManager.MANUAL_ASSIST_PROGRESS_PER_CLICK,
			CrawlerManager.MANUAL_ASSIST_SERVER_LOAD_PER_CLICK
		]

		return

	if CrawlerManager.paused_for_overload:
		manual_crawl_assist_button.tooltip_text = (
			"Manual assistance is unavailable while "
			+ "the server is cooling down."
		)

		return

	if CrawlerManager.is_current_job_complete():
		manual_crawl_assist_button.tooltip_text = (
			"The current crawl job is complete."
		)

		return

	manual_crawl_assist_button.tooltip_text = (
		"Start or resume the crawler to use "
		+ "Manual Crawl Assist."
	)


# -------------------------------------------------------------------
# Crawler signal callbacks
# -------------------------------------------------------------------

func _on_crawler_state_changed(is_running: bool) -> void:
	update_crawler_state(is_running)


func _on_crawler_progress_changed(
	pages_processed: int,
	target_pages: int,
	progress_percent: float
) -> void:
	update_crawler_progress(
		pages_processed,
		target_pages,
		progress_percent
	)

	update_crawler_state(
		GameState.crawler_running
	)


func _on_crawl_job_completed() -> void:
	update_crawler_progress(
		CrawlerManager.current_job_pages,
		CrawlerManager.get_current_job_target_pages(),
		CrawlerManager.get_progress_percent()
	)

	update_crawler_state(false)


# -------------------------------------------------------------------
# Crawler page status
# -------------------------------------------------------------------

func update_crawler_state(
	is_running: bool
) -> void:
	var pages_processed: int = (
		CrawlerManager.current_job_pages
	)

	var target_pages: int = (
		CrawlerManager.get_current_job_target_pages()
	)

	var job_complete: bool = (
		pages_processed >= target_pages
	)

	if job_complete:
		show_completed_state()

	elif CrawlerManager.paused_for_overload:
		show_overloaded_state()

	elif (
		is_running
		and GameState.server_load
		>= CrawlerManager.SERVER_LOAD_WARNING_THRESHOLD
	):
		show_warning_state()

	elif is_running:
		show_running_state()

	elif pages_processed > 0:
		show_paused_state()

	else:
		show_ready_state()
		
	refresh_crawl_job_selection()
	refresh_manual_crawl_assist_button()


func show_ready_state() -> void:
	crawler_page_status_label.text = "CRAWLER READY"

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	crawler_control_status_value_label.text = "Ready"
	current_job_state_value_label.text = "Ready"
	current_job_target_value_label.text = "Public Web Seed List"

	crawler_control_panel.set_status(
		"READY",
		ThemeManager.TEXT_DISABLED
	)

	current_crawl_job_panel.set_status(
		"READY",
		ThemeManager.TEXT_DISABLED
	)

	start_crawler_button.text = "Start Crawler"
	start_crawler_button.disabled = false
	pause_crawler_button.disabled = true


func show_running_state() -> void:
	crawler_page_status_label.text = "CRAWLER RUNNING"

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	crawler_control_status_value_label.text = "Running"
	current_job_state_value_label.text = "Running"
	current_job_target_value_label.text = "Public Web Seed List"

	crawler_control_panel.set_status(
		"RUNNING",
		ThemeManager.STATUS_SUCCESS
	)

	current_crawl_job_panel.set_status(
		"RUNNING",
		ThemeManager.STATUS_SUCCESS
	)

	start_crawler_button.text = "Crawler Running"
	start_crawler_button.disabled = true
	pause_crawler_button.disabled = false


func show_paused_state() -> void:
	crawler_page_status_label.text = "CRAWLER PAUSED"

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	crawler_control_status_value_label.text = "Paused"
	current_job_state_value_label.text = "Paused"
	current_job_target_value_label.text = "Public Web Seed List"

	crawler_control_panel.set_status(
		"PAUSED",
		ThemeManager.STATUS_WARNING
	)

	current_crawl_job_panel.set_status(
		"PAUSED",
		ThemeManager.STATUS_WARNING
	)

	start_crawler_button.text = "Resume Crawler"
	start_crawler_button.disabled = false
	pause_crawler_button.disabled = true


func show_completed_state() -> void:
	crawler_page_status_label.text = "CRAWL COMPLETE"

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	crawler_control_status_value_label.text = "Complete"
	current_job_state_value_label.text = "Complete"
	current_job_target_value_label.text = "Public Web Seed List"

	crawler_control_panel.set_status(
		"COMPLETE",
		ThemeManager.STATUS_SUCCESS
	)

	current_crawl_job_panel.set_status(
		"COMPLETE",
		ThemeManager.STATUS_SUCCESS
	)

	start_crawler_button.text = (
		"Start Next Crawl"
	)

	start_crawler_button.disabled = false

	pause_crawler_button.disabled = true
	
func show_warning_state() -> void:
	crawler_page_status_label.text = (
		"SERVER LOAD WARNING"
	)

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	crawler_control_status_value_label.text = (
		"Running — High Load"
	)

	current_job_state_value_label.text = (
		"Running"
	)

	current_job_target_value_label.text = (
		"Public Web Seed List"
	)

	crawler_control_panel.set_status(
		"WARNING",
		ThemeManager.STATUS_WARNING
	)

	current_crawl_job_panel.set_status(
		"RUNNING",
		ThemeManager.STATUS_WARNING
	)

	start_crawler_button.text = "Crawler Running"
	start_crawler_button.disabled = true

	pause_crawler_button.disabled = false
	
func show_overloaded_state() -> void:
	crawler_page_status_label.text = (
		"CRAWLER AUTO-PAUSED"
	)

	crawler_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_ERROR
	)

	crawler_control_status_value_label.text = (
		"Server Overload"
	)

	current_job_state_value_label.text = (
		"Cooling Down"
	)

	current_job_target_value_label.text = (
		"Public Web Seed List"
	)

	crawler_control_panel.set_status(
		"OVERLOAD",
		ThemeManager.STATUS_ERROR
	)

	current_crawl_job_panel.set_status(
		"PAUSED",
		ThemeManager.STATUS_ERROR
	)

	start_crawler_button.text = "Cooling Down"
	start_crawler_button.disabled = true

	pause_crawler_button.disabled = true


# -------------------------------------------------------------------
# Progress
# -------------------------------------------------------------------

func update_crawler_progress(
	pages_processed: int,
	target_pages: int,
	progress_percent: float
) -> void:
	var safe_processed: int = maxi(
		pages_processed,
		0
	)

	var safe_target: int = maxi(
		target_pages,
		1
	)

	var pages_remaining: int = maxi(
		safe_target - safe_processed,
		0
	)

	current_job_progress_bar.value = clampf(
		progress_percent,
		0.0,
		100.0
	)

	current_job_processed_value_label.text = (
		format_whole_number(safe_processed)
	)

	current_job_remaining_value_label.text = (
		format_whole_number(pages_remaining)
	)


# -------------------------------------------------------------------
# Statistics
# -------------------------------------------------------------------

func _on_indexed_pages_changed(new_value: int) -> void:
	statistics_indexed_pages_value_label.text = (
		format_whole_number(new_value)
	)


func _on_active_users_changed(new_value: int) -> void:
	statistics_active_users_value_label.text = (
		format_whole_number(new_value)
	)


func _on_server_load_changed(
	new_value: float
) -> void:
	statistics_server_load_value_label.text = (
		format_percentage(new_value)
	)

	update_crawler_state(
		GameState.crawler_running
	)


func _on_crawler_rate_changed(new_value: float) -> void:
	var rate_text: String = format_crawler_rate(
		new_value
	)

	crawler_control_rate_value_label.text = rate_text
	statistics_crawler_rate_value_label.text = rate_text


# -------------------------------------------------------------------
# Formatting
# -------------------------------------------------------------------

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
	return "%d%%" % roundi(
		clampf(value, 0.0, 100.0)
	)


func format_crawler_rate(value: float) -> String:
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
