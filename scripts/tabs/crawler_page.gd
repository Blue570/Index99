extends PanelContainer


# -------------------------------------------------------------------
# Manual Crawl Assist Constants
# -------------------------------------------------------------------

const MANUAL_ASSIST_FEEDBACK_DURATION: float = 0.16

const MANUAL_ASSIST_FLOAT_DURATION: float = 0.55

const MANUAL_ASSIST_COMBO_RESET_SECONDS: float = 0.75

const MANUAL_ASSIST_CLICK_SOUND: AudioStream = preload(
	"res://audio/manual_assist_click.wav"
)


# -------------------------------------------------------------------
# Page Header Nodes
# -------------------------------------------------------------------

@onready var crawler_page_status_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageHeader/"
	+ "CrawlerPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Crawler Control Nodes
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

@onready var auto_crawl_assist_status_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerAutomationStatusRow/"
	+ "AutoCrawlAssistStatusLabel"
) as Label

@onready var crawler_priority_status_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerAutomationStatusRow/"
	+ "CrawlerPriorityStatusLabel"
) as Label

@onready var speed_priority_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerPriorityButtonsRow/"
	+ "SpeedPriorityButton"
) as Button

@onready var balanced_priority_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerPriorityButtonsRow/"
	+ "BalancedPriorityButton"
) as Button

@onready var efficiency_priority_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerLeftColumn/CrawlerControlPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerControlLayout/CrawlerPriorityButtonsRow/"
	+ "EfficiencyPriorityButton"
) as Button


# -------------------------------------------------------------------
# Current Crawl Job Nodes
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
# Crawler Statistics Nodes
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


# -------------------------------------------------------------------
# Crawl Job Selection Nodes
# -------------------------------------------------------------------

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
# Live Crawler Event Nodes
# -------------------------------------------------------------------

@onready var live_crawler_event_panel: SectionPanel = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel"
) as SectionPanel

@onready var crawler_event_title_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerEventLayout/CrawlerEventTitleLabel"
) as Label

@onready var crawler_event_description_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerEventLayout/CrawlerEventDescriptionLabel"
) as Label

@onready var crawler_event_timer_label: Label = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerEventLayout/CrawlerEventTimerLabel"
) as Label

@onready var crawler_event_primary_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerEventLayout/CrawlerEventButtonsRow/"
	+ "CrawlerEventPrimaryButton"
) as Button

@onready var crawler_event_secondary_button: Button = get_node(
	"CrawlerMargin/CrawlerPageLayout/CrawlerPageBody/"
	+ "CrawlerRightColumn/LiveCrawlerEventPanel/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerEventLayout/CrawlerEventButtonsRow/"
	+ "CrawlerEventSecondaryButton"
) as Button

# -------------------------------------------------------------------
# Crawler Priority UI Runtime State
# -------------------------------------------------------------------

var crawler_priority_button_group: ButtonGroup = null


# -------------------------------------------------------------------
# Manual Crawl Assist Runtime State
# -------------------------------------------------------------------

var manual_assist_feedback_tween: Tween = null

var manual_assist_feedback_layer: Control = null
var manual_assist_combo_label: Label = null
var manual_assist_audio_player: AudioStreamPlayer = null

var manual_assist_combo_count: int = 0
var manual_assist_combo_generation: int = 0
var manual_assist_float_sequence: int = 0


# -------------------------------------------------------------------
# Crawler Event UI Runtime State
# -------------------------------------------------------------------

var crawler_event_ui_timer: Timer = null
var crawler_event_result_timer: Timer = null

const CRAWLER_EVENT_RESULT_DURATION_SECONDS: float = 1.50


# -------------------------------------------------------------------
# Lifecycle / Main Setup
# -------------------------------------------------------------------

func _ready() -> void:
	setup_progress_bar()
	setup_crawler_priority_buttons()
	
	connect_buttons()
	connect_crawler_signals()
	connect_game_state_signals()
	
	setup_manual_assist_feedback()
	setup_manual_assist_audio()
	
	setup_crawler_event_ui_timer()
	setup_crawler_event_result_timer()
	connect_crawler_event_signals()
	
	refresh_crawler_page()
	connect_progression_signals()


# -------------------------------------------------------------------
# Setup Helpers
# -------------------------------------------------------------------

func setup_progress_bar() -> void:
	current_job_progress_bar.min_value = 0.0
	current_job_progress_bar.max_value = 100.0
	current_job_progress_bar.step = 1.0
	current_job_progress_bar.show_percentage = true
	
func setup_crawler_priority_buttons() -> void:
	crawler_priority_button_group = ButtonGroup.new()

	crawler_priority_button_group.allow_unpress = false

	speed_priority_button.toggle_mode = true
	balanced_priority_button.toggle_mode = true
	efficiency_priority_button.toggle_mode = true

	speed_priority_button.button_group = (
		crawler_priority_button_group
	)

	balanced_priority_button.button_group = (
		crawler_priority_button_group
	)

	efficiency_priority_button.button_group = (
		crawler_priority_button_group
	)

	speed_priority_button.tooltip_text = (
		"Speed Priority\n"
		+ "+25% automatic work\n"
		+ "+30% automatic server load"
	)

	balanced_priority_button.tooltip_text = (
		"Balanced Priority\n"
		+ "Normal automatic work\n"
		+ "Normal automatic server load"
	)

	efficiency_priority_button.tooltip_text = (
		"Efficiency Priority\n"
		+ "-15% automatic work\n"
		+ "-30% automatic server load"
	)


func setup_manual_assist_feedback() -> void:
	manual_assist_feedback_layer = Control.new()

	manual_assist_feedback_layer.name = (
		"ManualAssistFeedbackLayer"
	)

	manual_assist_feedback_layer.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	manual_assist_feedback_layer.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	manual_assist_feedback_layer.z_index = 50

	add_child(
		manual_assist_feedback_layer
	)

	manual_assist_combo_label = Label.new()

	manual_assist_combo_label.name = (
		"ManualAssistComboLabel"
	)

	manual_assist_combo_label.text = ""

	manual_assist_combo_label.visible = false

	manual_assist_combo_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	manual_assist_combo_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	manual_assist_combo_label.custom_minimum_size = Vector2(
		150.0,
		26.0
	)

	manual_assist_combo_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	manual_assist_feedback_layer.add_child(
		manual_assist_combo_label
	)


func setup_manual_assist_audio() -> void:
	manual_assist_audio_player = AudioStreamPlayer.new()

	manual_assist_audio_player.name = (
		"ManualAssistAudioPlayer"
	)

	manual_assist_audio_player.stream = (
		MANUAL_ASSIST_CLICK_SOUND
	)

	manual_assist_audio_player.volume_db = -8.0

	add_child(
		manual_assist_audio_player
	)


func setup_crawler_event_ui_timer() -> void:
	crawler_event_ui_timer = Timer.new()

	crawler_event_ui_timer.name = (
		"CrawlerEventUITimer"
	)

	crawler_event_ui_timer.wait_time = 0.25
	crawler_event_ui_timer.one_shot = false
	crawler_event_ui_timer.autostart = false

	add_child(
		crawler_event_ui_timer
	)

	crawler_event_ui_timer.timeout.connect(
		_on_crawler_event_ui_timer_timeout
	)
	
func setup_crawler_event_result_timer() -> void:
	crawler_event_result_timer = Timer.new()

	crawler_event_result_timer.name = (
		"CrawlerEventResultTimer"
	)

	crawler_event_result_timer.wait_time = (
		CRAWLER_EVENT_RESULT_DURATION_SECONDS
	)

	crawler_event_result_timer.one_shot = true
	crawler_event_result_timer.autostart = false

	add_child(
		crawler_event_result_timer
	)

	crawler_event_result_timer.timeout.connect(
		_on_crawler_event_result_timer_timeout
	)
	


# -------------------------------------------------------------------
# Signal Connections
# -------------------------------------------------------------------

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
	
	if not crawler_event_primary_button.pressed.is_connected(
		_on_crawler_event_primary_button_pressed
	):
		crawler_event_primary_button.pressed.connect(
			_on_crawler_event_primary_button_pressed
		)

	if not crawler_event_secondary_button.pressed.is_connected(
		_on_crawler_event_secondary_button_pressed
	):
		crawler_event_secondary_button.pressed.connect(
			_on_crawler_event_secondary_button_pressed
		)
		
	if not speed_priority_button.pressed.is_connected(
		_on_speed_priority_button_pressed
	):
		speed_priority_button.pressed.connect(
			_on_speed_priority_button_pressed
		)

	if not balanced_priority_button.pressed.is_connected(
		_on_balanced_priority_button_pressed
	):
		balanced_priority_button.pressed.connect(
			_on_balanced_priority_button_pressed
		)

	if not efficiency_priority_button.pressed.is_connected(
		_on_efficiency_priority_button_pressed
	):
		efficiency_priority_button.pressed.connect(
			_on_efficiency_priority_button_pressed
		)


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
		
	if not AutomationManager.auto_crawl_assist_level_changed.is_connected(
		_on_auto_crawl_assist_level_changed
	):
		AutomationManager.auto_crawl_assist_level_changed.connect(
			_on_auto_crawl_assist_level_changed
		)
		
	if not CrawlerManager.crawler_priority_changed.is_connected(
		_on_crawler_priority_changed
	):
		CrawlerManager.crawler_priority_changed.connect(
			_on_crawler_priority_changed
		)


func connect_crawler_event_signals() -> void:
	if not CrawlerEventManager.crawler_event_started.is_connected(
		_on_crawler_event_started
	):
		CrawlerEventManager.crawler_event_started.connect(
			_on_crawler_event_started
		)

	if not CrawlerEventManager.crawler_event_cleared.is_connected(
		_on_crawler_event_cleared
	):
		CrawlerEventManager.crawler_event_cleared.connect(
			_on_crawler_event_cleared
		)

	if not CrawlerEventManager.crawler_event_expired.is_connected(
		_on_crawler_event_expired
	):
		CrawlerEventManager.crawler_event_expired.connect(
			_on_crawler_event_expired
		)

	if not CrawlerEventManager.crawler_event_resolved.is_connected(
		_on_crawler_event_resolved
	):
		CrawlerEventManager.crawler_event_resolved.connect(
			_on_crawler_event_resolved
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


func connect_progression_signals() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
	)


# -------------------------------------------------------------------
# Initial Page Refresh
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
	refresh_crawler_priority_ui()
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()

	refresh_crawler_event_ui()


# -------------------------------------------------------------------
# Crawler Control Button Callbacks
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
		return

	register_manual_assist_combo()

	spawn_manual_assist_floating_feedback()

	play_manual_assist_sound()

	play_manual_assist_click_feedback()


# -------------------------------------------------------------------
# Crawl Job Selection
# -------------------------------------------------------------------

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


# -------------------------------------------------------------------
# Progression
# -------------------------------------------------------------------

func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	refresh_crawl_job_selection()
	refresh_crawler_priority_ui()
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()
	
# -------------------------------------------------------------------
# Crawler Priority Controls and Display
# -------------------------------------------------------------------

func _on_speed_priority_button_pressed() -> void:
	select_crawler_priority(
		CrawlerManager.PRIORITY_SPEED
	)


func _on_balanced_priority_button_pressed() -> void:
	select_crawler_priority(
		CrawlerManager.PRIORITY_BALANCED
	)


func _on_efficiency_priority_button_pressed() -> void:
	select_crawler_priority(
		CrawlerManager.PRIORITY_EFFICIENCY
	)


func select_crawler_priority(
	priority_id: StringName
) -> void:
	CrawlerManager.set_crawler_priority(
		priority_id
	)

	refresh_crawler_priority_ui()
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()


func _on_crawler_priority_changed(
	_new_priority: StringName
) -> void:
	refresh_crawler_priority_ui()
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()


func refresh_crawler_priority_ui() -> void:
	var priority_unlocked: bool = (
		CrawlerManager.is_crawler_priority_unlocked()
	)

	var current_priority: StringName = (
		CrawlerManager.get_current_crawler_priority()
	)

	speed_priority_button.disabled = (
		not priority_unlocked
	)

	balanced_priority_button.disabled = (
		not priority_unlocked
	)

	efficiency_priority_button.disabled = (
		not priority_unlocked
	)

	if not priority_unlocked:
		speed_priority_button.button_pressed = false
		balanced_priority_button.button_pressed = false
		efficiency_priority_button.button_pressed = false

		crawler_priority_status_label.text = (
			"LOCKED | Unlocks at Tier 2"
		)

		crawler_priority_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		return

	speed_priority_button.button_pressed = (
		current_priority
		== CrawlerManager.PRIORITY_SPEED
	)

	balanced_priority_button.button_pressed = (
		current_priority
		== CrawlerManager.PRIORITY_BALANCED
	)

	efficiency_priority_button.button_pressed = (
		current_priority
		== CrawlerManager.PRIORITY_EFFICIENCY
	)

	var display_name: String = (
		CrawlerManager
		.get_current_crawler_priority_display_name()
	)

	var crawl_multiplier: float = (
		CrawlerManager.get_priority_crawl_multiplier()
	)

	var load_multiplier: float = (
		CrawlerManager.get_priority_load_multiplier()
	)

	var crawl_modifier_text: String = (
		format_priority_multiplier(
			crawl_multiplier
		)
	)

	var load_modifier_text: String = (
		format_priority_multiplier(
			load_multiplier
		)
	)

	crawler_priority_status_label.text = (
		"%s | Work: %s | Load: %s"
		% [
			display_name.to_upper(),
			crawl_modifier_text,
			load_modifier_text
		]
	)

	refresh_crawler_priority_color(
		current_priority
	)


func format_priority_multiplier(
	multiplier: float
) -> String:
	var modifier_percent: int = roundi(
		(multiplier - 1.0)
		* 100.0
	)

	if modifier_percent > 0:
		return (
			"+%d%%"
			% modifier_percent
		)

	if modifier_percent < 0:
		return (
			"%d%%"
			% modifier_percent
		)

	return "Normal"


func refresh_crawler_priority_color(
	priority_id: StringName
) -> void:
	var priority_color: Color = (
		ThemeManager.STATUS_INFORMATION
	)

	if priority_id == CrawlerManager.PRIORITY_SPEED:
		priority_color = (
			ThemeManager.STATUS_WARNING
		)

	elif (
		priority_id
		== CrawlerManager.PRIORITY_EFFICIENCY
	):
		priority_color = (
			ThemeManager.STATUS_SUCCESS
		)

	crawler_priority_status_label.add_theme_color_override(
		"font_color",
		priority_color
	)


# -------------------------------------------------------------------
# Manual Crawl Assist Feedback
# -------------------------------------------------------------------

func register_manual_assist_combo() -> void:
	manual_assist_combo_count += 1

	manual_assist_combo_generation += 1

	var current_generation: int = (
		manual_assist_combo_generation
	)

	refresh_manual_assist_combo_label()

	reset_manual_assist_combo_after_delay(
		current_generation
	)


func reset_manual_assist_combo_after_delay(
	expected_generation: int
) -> void:
	await get_tree().create_timer(
		MANUAL_ASSIST_COMBO_RESET_SECONDS
	).timeout

	if (
		expected_generation
		!= manual_assist_combo_generation
	):
		return

	manual_assist_combo_count = 0

	if manual_assist_combo_label != null:
		manual_assist_combo_label.visible = false


func refresh_manual_assist_combo_label() -> void:
	if manual_assist_combo_label == null:
		return

	if manual_assist_feedback_layer == null:
		return

	manual_assist_combo_label.text = (
		"ASSIST x%d"
		% manual_assist_combo_count
	)

	manual_assist_combo_label.visible = (
		manual_assist_combo_count >= 2
	)

	if manual_assist_combo_count >= 10:
		manual_assist_combo_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

	elif manual_assist_combo_count >= 5:
		manual_assist_combo_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

	else:
		manual_assist_combo_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_INFORMATION
		)

	position_manual_assist_combo_label()


func position_manual_assist_combo_label() -> void:
	if manual_assist_combo_label == null:
		return

	if manual_assist_feedback_layer == null:
		return

	var button_rect: Rect2 = (
		manual_crawl_assist_button.get_global_rect()
	)

	var layer_position: Vector2 = (
		manual_assist_feedback_layer.global_position
	)

	var label_width: float = (
		manual_assist_combo_label.custom_minimum_size.x
	)

	manual_assist_combo_label.position = Vector2(
		button_rect.position.x
		- layer_position.x
		+ button_rect.size.x
		- label_width,
		button_rect.position.y
		- layer_position.y
		- 30.0
	)


func spawn_manual_assist_floating_feedback() -> void:
	manual_assist_float_sequence += 1

	var spread_index: int = (
		manual_assist_float_sequence % 3
	)

	var horizontal_spread: float = (
		float(spread_index - 1)
		* 12.0
	)

	spawn_manual_assist_float_label(
		"+%.2f WORK"
		% CrawlerManager.MANUAL_ASSIST_PROGRESS_PER_CLICK,
		ThemeManager.STATUS_SUCCESS,
		-70.0 + horizontal_spread,
		Vector2(
			-12.0,
			-42.0
		)
	)

	spawn_manual_assist_float_label(
		"+%.2f LOAD"
		% CrawlerManager.MANUAL_ASSIST_SERVER_LOAD_PER_CLICK,
		ThemeManager.STATUS_WARNING,
		35.0 + horizontal_spread,
		Vector2(
			12.0,
			-42.0
		)
	)


func spawn_manual_assist_float_label(
	label_text: String,
	label_color: Color,
	horizontal_offset: float,
	movement: Vector2
) -> void:
	if manual_assist_feedback_layer == null:
		return

	var floating_label: Label = Label.new()

	floating_label.text = label_text

	floating_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	floating_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_CENTER
	)

	floating_label.custom_minimum_size = Vector2(
		105.0,
		24.0
	)

	floating_label.size = Vector2(
		105.0,
		24.0
	)

	floating_label.add_theme_color_override(
		"font_color",
		label_color
	)

	manual_assist_feedback_layer.add_child(
		floating_label
	)

	var button_rect: Rect2 = (
		manual_crawl_assist_button.get_global_rect()
	)

	var layer_position: Vector2 = (
		manual_assist_feedback_layer.global_position
	)

	var button_center_x: float = (
		button_rect.position.x
		- layer_position.x
		+ button_rect.size.x * 0.5
	)

	var button_top_y: float = (
		button_rect.position.y
		- layer_position.y
	)

	var start_position: Vector2 = Vector2(
		button_center_x
		- 52.5
		+ horizontal_offset,
		button_top_y - 4.0
	)

	floating_label.position = (
		start_position
	)

	var target_position: Vector2 = (
		start_position + movement
	)

	var floating_tween: Tween = create_tween()

	floating_tween.set_parallel(
		true
	)

	floating_tween.tween_property(
		floating_label,
		"position",
		target_position,
		MANUAL_ASSIST_FLOAT_DURATION
	).set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_OUT
	)

	floating_tween.tween_property(
		floating_label,
		"modulate",
		Color(
			1.0,
			1.0,
			1.0,
			0.0
		),
		MANUAL_ASSIST_FLOAT_DURATION
	)

	floating_tween.finished.connect(
		floating_label.queue_free
	)


func play_manual_assist_sound() -> void:
	if manual_assist_audio_player == null:
		return

	var combo_pitch_steps: int = mini(
		manual_assist_combo_count - 1,
		8
	)

	var pitch_bonus: float = (
		float(combo_pitch_steps)
		* 0.025
	)

	manual_assist_audio_player.pitch_scale = (
		1.0 + pitch_bonus
	)

	manual_assist_audio_player.stop()

	manual_assist_audio_player.play()


func play_manual_assist_click_feedback() -> void:
	if manual_assist_feedback_tween != null:
		if manual_assist_feedback_tween.is_valid():
			manual_assist_feedback_tween.kill()

	manual_crawl_assist_button.text = (
		"+%.2f WORK  |  +%.2f LOAD"
		% [
			CrawlerManager.MANUAL_ASSIST_PROGRESS_PER_CLICK,
			CrawlerManager.MANUAL_ASSIST_SERVER_LOAD_PER_CLICK
		]
	)

	manual_crawl_assist_button.self_modulate = Color(
		1.0,
		1.0,
		0.72,
		1.0
	)

	manual_assist_feedback_tween = create_tween()

	manual_assist_feedback_tween.tween_property(
		manual_crawl_assist_button,
		"self_modulate",
		Color.WHITE,
		MANUAL_ASSIST_FEEDBACK_DURATION
	)

	manual_assist_feedback_tween.finished.connect(
		_on_manual_assist_feedback_finished
	)


func _on_manual_assist_feedback_finished() -> void:
	manual_assist_feedback_tween = null

	refresh_manual_crawl_assist_button()


func refresh_manual_crawl_assist_button() -> void:
	var assist_available: bool = (
		CrawlerManager.can_use_manual_crawl_assist()
	)

	manual_crawl_assist_button.disabled = (
		not assist_available
	)

	if manual_assist_feedback_tween == null:
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
# Auto Crawl Assist Display
# -------------------------------------------------------------------

func _on_auto_crawl_assist_level_changed(
	_new_level: int
) -> void:
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()


func refresh_auto_crawl_assist_status() -> void:
	if not AutomationManager.is_auto_assist_unlocked():
		auto_crawl_assist_status_label.text = (
			"Auto Crawl Assist: LOCKED"
		)

		auto_crawl_assist_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		auto_crawl_assist_status_label.tooltip_text = (
			"Unlocks with Tier 2 after completing "
			+ "the Index 500 Pages objective."
		)

		return

	var assist_level: int = (
		AutomationManager.get_auto_assist_level()
	)

	var status_prefix: String = (
		"Auto Crawl Assist L%d"
		% assist_level
	)

	if CrawlerManager.paused_for_overload:
		auto_crawl_assist_status_label.text = (
			status_prefix + ": COOLING"
		)

		auto_crawl_assist_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

		auto_crawl_assist_status_label.tooltip_text = (
			"Automation pauses while the "
			+ "server cools down."
		)

		return

	if CrawlerManager.is_current_job_complete():
		auto_crawl_assist_status_label.text = (
			status_prefix + ": IDLE"
		)

		auto_crawl_assist_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		auto_crawl_assist_status_label.tooltip_text = (
			"Start the next crawl to resume automation."
		)

		return

	if GameState.crawler_running:
		auto_crawl_assist_status_label.text = (
			status_prefix
			+ ": ACTIVE (+%.2f/sec)"
			% AutomationManager
			.get_auto_assist_work_per_second()
		)

		auto_crawl_assist_status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		auto_crawl_assist_status_label.tooltip_text = (
			"Level %d | +%.2f work/sec | "
			+ "+%.2f server load/sec"
		) % [
			assist_level,
			AutomationManager
			.get_auto_assist_work_per_second(),
			AutomationManager
			.get_auto_assist_load_per_second()
		]

		return

	auto_crawl_assist_status_label.text = (
		status_prefix + ": READY"
	)

	auto_crawl_assist_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)

	auto_crawl_assist_status_label.tooltip_text = (
		"Level %d | +%.2f work/sec | "
		+ "+%.2f server load/sec. "
		+ "Automation begins automatically "
		+ "when the crawler is running."
	) % [
		assist_level,
		AutomationManager
		.get_auto_assist_work_per_second(),
		AutomationManager
		.get_auto_assist_load_per_second()
	]


func refresh_effective_crawler_rate() -> void:
	var effective_rate: float = (
		AutomationManager
		.get_effective_total_crawl_rate()
	)

	var rate_text: String = format_crawler_rate(
		effective_rate
	)

	crawler_control_rate_value_label.text = (
		rate_text
	)

	statistics_crawler_rate_value_label.text = (
		rate_text
	)


# -------------------------------------------------------------------
# Live Crawler Event UI
# -------------------------------------------------------------------

func refresh_crawler_event_ui() -> void:
	if CrawlerEventManager.has_active_event():
		show_crawler_event(
			CrawlerEventManager.get_active_event()
		)
		return

	show_crawler_event_idle_state()


func _on_crawler_event_primary_button_pressed() -> void:
	CrawlerEventManager.resolve_active_event(
		CrawlerEventManager.ACTION_PRIMARY
	)


func _on_crawler_event_secondary_button_pressed() -> void:
	CrawlerEventManager.resolve_active_event(
		CrawlerEventManager.ACTION_SECONDARY
	)


func _on_crawler_event_started(
	event_data: Dictionary
) -> void:
	show_crawler_event(
		event_data
	)


func show_crawler_event(
	event_data: Dictionary
) -> void:
	if crawler_event_result_timer != null:
		crawler_event_result_timer.stop()
	var event_title: String = str(
		event_data.get(
			"title",
			"CRAWLER EVENT"
		)
	)

	var event_description: String = str(
		event_data.get(
			"description",
			"An event has occurred."
		)
	)

	var primary_action: String = str(
		event_data.get(
			"primary_action",
			"Action"
		)
	)

	var secondary_action: String = str(
		event_data.get(
			"secondary_action",
			"Skip"
		)
	)
	
	var primary_effect_text: String = str(
		event_data.get(
			"primary_effect_text",
			""
		)
	)

	crawler_event_title_label.text = (
		event_title
	)

	crawler_event_description_label.text = (
		"%s\n%s: %s"
		% [
			event_description,
			primary_action,
			primary_effect_text
		]
	)

	crawler_event_primary_button.text = (
		primary_action
	)

	crawler_event_secondary_button.text = (
		secondary_action
	)

	crawler_event_primary_button.disabled = false
	crawler_event_secondary_button.disabled = false

	live_crawler_event_panel.set_status(
		"EVENT",
		ThemeManager.STATUS_WARNING
	)

	refresh_crawler_event_countdown()

	crawler_event_ui_timer.start()


func _on_crawler_event_ui_timer_timeout() -> void:
	refresh_crawler_event_countdown()


func refresh_crawler_event_countdown() -> void:
	if not CrawlerEventManager.has_active_event():
		crawler_event_ui_timer.stop()
		return

	var time_remaining: float = (
		CrawlerEventManager
		.get_event_time_remaining()
	)

	var seconds_remaining: int = maxi(
		ceili(time_remaining),
		0
	)

	crawler_event_timer_label.text = (
		"Expires in: %d sec"
		% seconds_remaining
	)


func show_crawler_event_idle_state() -> void:
	if crawler_event_ui_timer != null:
		crawler_event_ui_timer.stop()

	crawler_event_title_label.text = (
		"MONITORING CRAWL ACTIVITY"
	)

	crawler_event_description_label.text = (
		"No active crawler event."
	)

	crawler_event_timer_label.text = (
		"Waiting for event..."
	)

	crawler_event_primary_button.text = (
		"ACTION"
	)

	crawler_event_secondary_button.text = (
		"SKIP"
	)

	crawler_event_primary_button.disabled = true
	crawler_event_secondary_button.disabled = true

	live_crawler_event_panel.set_status(
		"MONITORING",
		ThemeManager.TEXT_DISABLED
	)


func _on_crawler_event_cleared() -> void:
	show_crawler_event_idle_state()


func _on_crawler_event_expired(
	_event_id: StringName
) -> void:
	show_crawler_event_idle_state()


func _on_crawler_event_resolved(
	_event_id: StringName,
	_action_id: StringName
) -> void:
	var result_data: Dictionary = (
		CrawlerEventManager
		.get_last_event_result()
	)

	show_crawler_event_result(
		result_data
	)
	
func show_crawler_event_result(
	result_data: Dictionary
) -> void:
	crawler_event_ui_timer.stop()

	var result_title: String = str(
		result_data.get(
			"title",
			"EVENT RESOLVED"
		)
	)

	var result_message: String = str(
		result_data.get(
			"message",
			"No changes applied."
		)
	)

	var primary_result: bool = bool(
		result_data.get(
			"primary",
			false
		)
	)

	crawler_event_title_label.text = (
		result_title
	)

	crawler_event_description_label.text = (
		result_message
	)

	crawler_event_timer_label.text = (
		"Result applied."
	)

	crawler_event_primary_button.text = (
		"ACTION"
	)

	crawler_event_secondary_button.text = (
		"SKIP"
	)

	crawler_event_primary_button.disabled = true
	crawler_event_secondary_button.disabled = true

	if primary_result:
		live_crawler_event_panel.set_status(
			"RESULT",
			ThemeManager.STATUS_SUCCESS
		)

	else:
		live_crawler_event_panel.set_status(
			"PASSED",
			ThemeManager.TEXT_DISABLED
		)

	crawler_event_result_timer.start()
	
func _on_crawler_event_result_timer_timeout() -> void:
	refresh_crawler_event_ui()


# -------------------------------------------------------------------
# Crawler Manager Signal Callbacks
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
# Crawler Page State Display
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
	refresh_auto_crawl_assist_status()
	refresh_effective_crawler_rate()


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
# Crawl Progress Display
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
# GameState / Statistics Callbacks
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


func _on_crawler_rate_changed(
	_new_value: float
) -> void:
	refresh_effective_crawler_rate()


# -------------------------------------------------------------------
# Formatting Helpers
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
