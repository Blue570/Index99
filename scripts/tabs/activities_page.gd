extends PanelContainer


# -------------------------------------------------------------------
# Activity Configuration
# -------------------------------------------------------------------

const ACTIVITY_MANUAL_INDEX_REVIEW: StringName = (
	&"manual_index_review"
)

const ACTIVITY_BROKEN_LINK_CLEANUP: StringName = (
	&"broken_link_cleanup"
)

const REVIEW_PAGE_COUNT: int = 5
const MONEY_REWARD_PER_CORRECT: float = 5.0
const PERFECT_REVIEW_RESEARCH_REWARD: float = 1.0

const REVIEW_WINDOW_TEXT_COLOR: Color = Color("#202020")

const REVIEW_WINDOW_DISABLED_TEXT_COLOR: Color = Color("#707070")

const REVIEW_PANEL_BACKGROUND_COLOR: Color = Color("#E8E8E8")

const REVIEW_PANEL_BORDER_COLOR: Color = Color("#808080")

const REVIEW_FEEDBACK_BACKGROUND_COLOR: Color = Color("#D6D6D6")

const REVIEW_FEEDBACK_BORDER_COLOR: Color = Color("#808080")

const REVIEW_ACCEPT_HOVER_COLOR: Color = Color("#4F6E4F")

const REVIEW_REJECT_HOVER_COLOR: Color = Color("#7A4A4A")

const REVIEW_BUTTON_NORMAL_COLOR: Color = Color("#D4D0C8")

const REVIEW_BUTTON_PRESSED_COLOR: Color = Color("#B0B0B0")

const REVIEW_CLOSE_HOVER_COLOR: Color = Color("#4A5F7A")

const REVIEW_WINDOW_BACKGROUND_COLOR: Color = Color("#C0C0C0")

const REVIEW_WINDOW_BORDER_COLOR: Color = Color("#404040")


const REVIEW_CASES: Array[Dictionary] = [
	{
		"url": "http://www.bytewire.net/news/archive.html",
		"status_code": 200,
		"content_size_kb": 18.4,
		"duplicate": false,
		"spam": false,
		"should_accept": true
	},
	{
		"url": "http://www.webdeals99.com/free-money.html",
		"status_code": 200,
		"content_size_kb": 9.7,
		"duplicate": false,
		"spam": true,
		"should_accept": false
	},
	{
		"url": "http://www.techbase.org/articles/cpu-guide.htm",
		"status_code": 404,
		"content_size_kb": 0.8,
		"duplicate": false,
		"spam": false,
		"should_accept": false
	},
	{
		"url": "http://www.gamezone.net/reviews/latest.htm",
		"status_code": 200,
		"content_size_kb": 14.2,
		"duplicate": false,
		"spam": false,
		"should_accept": true
	},
	{
		"url": "http://www.searchworld.com/directory/index.htm",
		"status_code": 200,
		"content_size_kb": 21.5,
		"duplicate": true,
		"spam": false,
		"should_accept": false
	},
	{
		"url": "http://www.networkdaily.net/features/modems.htm",
		"status_code": 200,
		"content_size_kb": 7.1,
		"duplicate": false,
		"spam": false,
		"should_accept": true
	},
	{
		"url": "http://www.superlinks.net/page23.htm",
		"status_code": 500,
		"content_size_kb": 0.0,
		"duplicate": false,
		"spam": false,
		"should_accept": false
	},
	{
		"url": "http://www.pcgarage.org/drivers/video.htm",
		"status_code": 200,
		"content_size_kb": 1.3,
		"duplicate": false,
		"spam": false,
		"should_accept": false
	},
	{
		"url": "http://www.digitalcorner.net/tutorials/html.htm",
		"status_code": 200,
		"content_size_kb": 11.6,
		"duplicate": false,
		"spam": false,
		"should_accept": true
	},
	{
		"url": "http://www.click4cash99.net/winner.htm",
		"status_code": 200,
		"content_size_kb": 4.5,
		"duplicate": false,
		"spam": true,
		"should_accept": false
	}
]


# -------------------------------------------------------------------
# Node References
# -------------------------------------------------------------------

@onready var manual_index_review_card: ActivityCard = (
	$ActivitiesMargin/ActivitiesPageLayout
	/ActivitiesScroll/ActivitiesCatalog
	/ManualIndexReviewCard
)

@onready var broken_link_cleanup_card: ActivityCard = (
	find_child(
		"BrokenLinkCleanupCard",
		true,
		false
	) as ActivityCard
)


# -------------------------------------------------------------------
# Review Window
# -------------------------------------------------------------------

@onready var review_window: PanelContainer = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow"
	) as PanelContainer
)

@onready var review_window_header_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowHeaderPanel"
	) as PanelContainer
)

@onready var review_window_title_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowHeaderPanel/"
		+ "ReviewWindowHeader/"
		+ "ReviewWindowTitleLabel"
	) as Label
)

@onready var review_minimize_button: Button = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowHeaderPanel/"
		+ "ReviewWindowHeader/"
		+ "ReviewMinimizeButton"
	) as Button
)

@onready var review_progress_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewPageInfoPanel/"
		+ "ReviewPageInfoMargin/ReviewPageInfoLayout/"
		+ "ReviewProgressLabel"
	) as Label
)

@onready var review_url_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewPageInfoPanel/"
		+ "ReviewPageInfoMargin/ReviewPageInfoLayout/"
		+ "ReviewUrlLabel"
	) as Label
)

@onready var review_data_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewPageInfoPanel/"
		+ "ReviewPageInfoMargin/ReviewPageInfoLayout/"
		+ "ReviewDataLabel"
	) as Label
)

@onready var accept_button: Button = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewDecisionRow/AcceptButton"
	) as Button
)

@onready var reject_button: Button = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewDecisionRow/RejectButton"
	) as Button
)

@onready var review_feedback_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewFeedbackPanel/"
		+ "ReviewFeedbackLabel"
	) as Label
)

@onready var review_feedback_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewFeedbackPanel"
	) as PanelContainer
)

@onready var minimized_review_button: Button = (
	get_tree().current_scene.get_node(
		"MainApplicationWindow/MainLayout/"
		+ "BackgroundJobsBar/JobsLayout/"
		+ "MinimizedManualIndexReviewButton"
	) as Button
)

@onready var review_page_info_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewPageInfoPanel"
	) as PanelContainer
)

@onready var review_rules_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewRulesPanel"
	) as PanelContainer
)

@onready var review_page_info_header_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewPageInfoPanel/"
		+ "ReviewPageInfoMargin/ReviewPageInfoLayout/"
		+ "ReviewPageInfoHeaderLabel"
	) as Label
)

@onready var review_rules_header_label: Label = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewWindowBody/ReviewRulesPanel/"
		+ "ReviewRulesMargin/ReviewRulesLayout/"
		+ "ReviewRulesHeaderLabel"
	) as Label
)

@onready var close_review_button: Button = (
	get_tree().current_scene.get_node(
		"ManualIndexReviewWindow/"
		+ "ReviewWindowMargin/ReviewWindowLayout/"
		+ "ReviewDecisionRow/CloseReviewButton"
	) as Button
)


# -------------------------------------------------------------------
# Broken Link Cleanup Window
# -------------------------------------------------------------------

@onready var cleanup_window: PanelContainer = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow"
	) as PanelContainer
)

@onready var cleanup_window_header_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowHeaderPanel"
	) as PanelContainer
)

@onready var cleanup_window_title_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowHeaderPanel/"
		+ "CleanupWindowHeader/"
		+ "CleanupWindowTitleLabel"
	) as Label
)

@onready var cleanup_minimize_button: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowHeaderPanel/"
		+ "CleanupWindowHeader/"
		+ "CleanupMinimizeButton"
	) as Button
)

@onready var cleanup_progress_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupLinkInfoPanel/"
		+ "CleanupLinkInfoMargin/CleanupLinkInfoLayout/"
		+ "CleanupProgressLabel"
	) as Label
)

@onready var cleanup_url_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupLinkInfoPanel/"
		+ "CleanupLinkInfoMargin/CleanupLinkInfoLayout/"
		+ "CleanupUrlLabel"
	) as Label
)

@onready var cleanup_link_data_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupLinkInfoPanel/"
		+ "CleanupLinkInfoMargin/CleanupLinkInfoLayout/"
		+ "CleanupLinkDataLabel"
	) as Label
)

@onready var cleanup_feedback_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupFeedbackPanel"
	) as PanelContainer
)

@onready var cleanup_feedback_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupFeedbackPanel/"
		+ "CleanupFeedbackLabel"
	) as Label
)

@onready var cleanup_link_info_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupLinkInfoPanel"
	) as PanelContainer
)

@onready var cleanup_instructions_panel: PanelContainer = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupInstructionsPanel"
	) as PanelContainer
)

@onready var cleanup_link_info_header_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupLinkInfoPanel/"
		+ "CleanupLinkInfoMargin/CleanupLinkInfoLayout/"
		+ "CleanupLinkInfoHeaderLabel"
	) as Label
)

@onready var cleanup_instructions_header_label: Label = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupWindowBody/CleanupInstructionsPanel/"
		+ "CleanupInstructionsMargin/"
		+ "CleanupInstructionsLayout/"
		+ "CleanupInstructionsHeaderLabel"
	) as Label
)

@onready var cleanup_answer_button_1: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupAnswerGrid/CleanupAnswerButton1"
	) as Button
)

@onready var cleanup_answer_button_2: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupAnswerGrid/CleanupAnswerButton2"
	) as Button
)

@onready var cleanup_answer_button_3: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupAnswerGrid/CleanupAnswerButton3"
	) as Button
)

@onready var cleanup_answer_button_4: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CleanupAnswerGrid/CleanupAnswerButton4"
	) as Button
)

@onready var close_cleanup_button: Button = (
	get_tree().current_scene.get_node(
		"BrokenLinkCleanupWindow/"
		+ "CleanupWindowMargin/CleanupWindowLayout/"
		+ "CloseCleanupButton"
	) as Button
)

@onready var minimized_cleanup_button: Button = (
	get_tree().current_scene.get_node(
		"MainApplicationWindow/MainLayout/"
		+ "BackgroundJobsBar/JobsLayout/"
		+ "MinimizedBrokenLinkCleanupButton"
	) as Button
)


# -------------------------------------------------------------------
# Runtime State
# -------------------------------------------------------------------

var active_review_cases: Array[Dictionary] = []

var current_review_index: int = 0
var correct_review_count: int = 0

var review_active: bool = false
var review_completed: bool = false

var cleanup_active: bool = false
var cleanup_completed: bool = false


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	setup_manual_index_review_card()
	setup_broken_link_cleanup_card()
	setup_broken_link_cleanup_workspace()

	connect_activity_stats_signals()
	connect_buttons()

	apply_activity_window_shell_theme(
		review_window
	)

	apply_review_window_font_colors()
	apply_review_window_title_bar_theme()
	apply_review_window_content_theme()
	apply_review_window_bottom_theme()

	apply_activity_window_shell_theme(
		cleanup_window
	)

	apply_cleanup_window_font_colors()
	apply_cleanup_window_title_bar_theme()
	apply_cleanup_window_content_theme()
	apply_cleanup_window_bottom_theme()

	review_window.visible = false
	minimized_review_button.visible = false

	close_review_button.visible = false
	close_review_button.disabled = true

	cleanup_window.visible = false
	minimized_cleanup_button.visible = false

	close_cleanup_button.visible = false
	close_cleanup_button.disabled = true

	
func setup_manual_index_review_card() -> void:
	manual_index_review_card.configure(
		ACTIVITY_MANUAL_INDEX_REVIEW,
		"MANUAL INDEX REVIEW",
		"Review discovered pages before adding them to the index.",
		"10-20 sec",
		"$5/correct + Perfect RP",
		"START REVIEW"
	)

	manual_index_review_card.set_completion_count(
		ActivityStatsManager.get_type_completed(
			ACTIVITY_MANUAL_INDEX_REVIEW
		)
	)
	
func setup_broken_link_cleanup_card() -> void:
	broken_link_cleanup_card.configure(
		ACTIVITY_BROKEN_LINK_CLEANUP,
		"BROKEN LINK CLEANUP",
		"Identify broken URLs and choose the correct repair.",
		"15-30 sec",
		"$5/correct + Perfect RP",
		"START CLEANUP"
	)

	broken_link_cleanup_card.set_completion_count(
		ActivityStatsManager.get_type_completed(
			ACTIVITY_BROKEN_LINK_CLEANUP
		)
	)
	
func setup_broken_link_cleanup_workspace() -> void:
	cleanup_progress_label.text = (
		"RECORD 1 OF 5"
	)

	cleanup_url_label.text = (
		"URL: www.example99.com/downloads/"
		+ "video_driver_98.zip"
	)

	cleanup_link_data_label.text = (
		"Server Response: 404 - File Not Found\n"
		+ "Requested File: video_driver_98.zip"
	)

	cleanup_feedback_label.text = (
		"Select the best repair option."
	)

	cleanup_answer_button_1.text = "OPTION A"
	cleanup_answer_button_2.text = "OPTION B"
	cleanup_answer_button_3.text = "OPTION C"
	cleanup_answer_button_4.text = "OPTION D"

# -------------------------------------------------------------------
# Activity Statistics
# -------------------------------------------------------------------
	
func connect_activity_stats_signals() -> void:
	if not ActivityStatsManager.activity_stats_reset.is_connected(
		_on_activity_stats_reset
	):
		ActivityStatsManager.activity_stats_reset.connect(
			_on_activity_stats_reset
		)
		
func _on_activity_stats_reset() -> void:
	refresh_activity_completion_counts()
	
func refresh_activity_completion_counts() -> void:
	manual_index_review_card.set_completion_count(
		ActivityStatsManager.get_type_completed(
			ACTIVITY_MANUAL_INDEX_REVIEW
		)
	)

	broken_link_cleanup_card.set_completion_count(
		ActivityStatsManager.get_type_completed(
			ACTIVITY_BROKEN_LINK_CLEANUP
		)
	)
	
# -------------------------------------------------------------------
# Review Window Theme
# -------------------------------------------------------------------

func apply_activity_window_shell_theme(
	window: PanelContainer
) -> void:
	var window_style: StyleBoxFlat = (
		StyleBoxFlat.new()
	)

	window_style.bg_color = (
		REVIEW_WINDOW_BACKGROUND_COLOR
	)

	window_style.border_color = (
		REVIEW_WINDOW_BORDER_COLOR
	)

	window_style.border_width_left = 2
	window_style.border_width_top = 2
	window_style.border_width_right = 2
	window_style.border_width_bottom = 2

	window_style.corner_radius_top_left = 0
	window_style.corner_radius_top_right = 0
	window_style.corner_radius_bottom_left = 0
	window_style.corner_radius_bottom_right = 0

	window.add_theme_stylebox_override(
		"panel",
		window_style
	)

func apply_review_window_font_colors() -> void:
	apply_font_color_recursive(
		review_window
	)
	
func apply_cleanup_window_font_colors() -> void:
	apply_font_color_recursive(
		cleanup_window
	)
	
func apply_review_window_title_bar_theme() -> void:
	review_window_header_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_title_bar_style()
	)

	review_window_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	review_minimize_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	review_minimize_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	review_minimize_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)

	review_minimize_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	review_minimize_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_PRIMARY
	)

	review_minimize_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)
	
func apply_cleanup_window_title_bar_theme() -> void:
	cleanup_window_header_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_title_bar_style()
	)

	cleanup_window_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)

	cleanup_minimize_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	cleanup_minimize_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	cleanup_minimize_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)

	cleanup_minimize_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	cleanup_minimize_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_PRIMARY
	)

	cleanup_minimize_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)


func apply_font_color_recursive(
	node: Node
) -> void:
	if node is Label:
		var label := node as Label

		label.add_theme_color_override(
			"font_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

	elif node is Button:
		var button := node as Button

		button.add_theme_color_override(
			"font_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

		button.add_theme_color_override(
			"font_hover_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

		button.add_theme_color_override(
			"font_pressed_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

		button.add_theme_color_override(
			"font_focus_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

		button.add_theme_color_override(
			"font_hover_pressed_color",
			REVIEW_WINDOW_TEXT_COLOR
		)

		button.add_theme_color_override(
			"font_disabled_color",
			REVIEW_WINDOW_DISABLED_TEXT_COLOR
		)

	for child: Node in node.get_children():
		apply_font_color_recursive(
			child
		)


func connect_buttons() -> void:
	
	if not manual_index_review_card.start_requested.is_connected(
		_on_activity_card_start_requested
	):
		manual_index_review_card.start_requested.connect(
			_on_activity_card_start_requested
		)
		
	if not broken_link_cleanup_card.start_requested.is_connected(
		_on_activity_card_start_requested
	):
		broken_link_cleanup_card.start_requested.connect(
			_on_activity_card_start_requested
		)

	if not accept_button.pressed.is_connected(
		_on_accept_button_pressed
	):
		accept_button.pressed.connect(
			_on_accept_button_pressed
		)

	if not reject_button.pressed.is_connected(
		_on_reject_button_pressed
	):
		reject_button.pressed.connect(
			_on_reject_button_pressed
		)

	if not close_review_button.pressed.is_connected(
		_on_close_review_button_pressed
	):
		close_review_button.pressed.connect(
			_on_close_review_button_pressed
		)

	if not review_minimize_button.pressed.is_connected(
		_on_review_minimize_button_pressed
	):
		review_minimize_button.pressed.connect(
			_on_review_minimize_button_pressed
		)

	if not minimized_review_button.pressed.is_connected(
		_on_minimized_review_button_pressed
	):
		minimized_review_button.pressed.connect(
			_on_minimized_review_button_pressed
		)
		
	if not cleanup_minimize_button.pressed.is_connected(
		_on_cleanup_minimize_button_pressed
	):
		cleanup_minimize_button.pressed.connect(
			_on_cleanup_minimize_button_pressed
		)

	if not minimized_cleanup_button.pressed.is_connected(
		_on_minimized_cleanup_button_pressed
	):
		minimized_cleanup_button.pressed.connect(
			_on_minimized_cleanup_button_pressed
		)

	if not close_cleanup_button.pressed.is_connected(
		_on_close_cleanup_button_pressed
	):
		close_cleanup_button.pressed.connect(
			_on_close_cleanup_button_pressed
		)
		
func _on_activity_card_start_requested(
	activity_id: StringName
) -> void:
	if activity_id == ACTIVITY_MANUAL_INDEX_REVIEW:
		start_manual_index_review()
		return

	if activity_id == ACTIVITY_BROKEN_LINK_CLEANUP:
		start_broken_link_cleanup()
		return

	push_warning(
		"ActivitiesPage: Unknown activity ID: %s"
		% activity_id
	)
		
func apply_review_window_content_theme() -> void:
	var content_panels: Array[PanelContainer] = [
		review_page_info_panel,
		review_rules_panel
	]

	for panel: PanelContainer in content_panels:
		var panel_style: StyleBoxFlat = (
			StyleBoxFlat.new()
		)

		panel_style.bg_color = (
			REVIEW_PANEL_BACKGROUND_COLOR
		)

		panel_style.border_color = (
			REVIEW_PANEL_BORDER_COLOR
		)

		panel_style.border_width_left = 1
		panel_style.border_width_top = 1
		panel_style.border_width_right = 1
		panel_style.border_width_bottom = 1

		panel_style.corner_radius_top_left = 0
		panel_style.corner_radius_top_right = 0
		panel_style.corner_radius_bottom_left = 0
		panel_style.corner_radius_bottom_right = 0

		panel.add_theme_stylebox_override(
			"panel",
			panel_style
		)

	review_page_info_header_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	review_rules_header_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	review_page_info_header_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	review_rules_header_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	review_progress_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)
	
func apply_cleanup_window_content_theme() -> void:
	var content_panels: Array[PanelContainer] = [
		cleanup_link_info_panel,
		cleanup_instructions_panel
	]

	for panel: PanelContainer in content_panels:
		var panel_style: StyleBoxFlat = (
			StyleBoxFlat.new()
		)

		panel_style.bg_color = (
			REVIEW_PANEL_BACKGROUND_COLOR
		)

		panel_style.border_color = (
			REVIEW_PANEL_BORDER_COLOR
		)

		panel_style.border_width_left = 1
		panel_style.border_width_top = 1
		panel_style.border_width_right = 1
		panel_style.border_width_bottom = 1

		panel_style.corner_radius_top_left = 0
		panel_style.corner_radius_top_right = 0
		panel_style.corner_radius_bottom_left = 0
		panel_style.corner_radius_bottom_right = 0

		panel.add_theme_stylebox_override(
			"panel",
			panel_style
		)

	cleanup_link_info_header_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	cleanup_instructions_header_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	cleanup_link_info_header_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	cleanup_instructions_header_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	cleanup_progress_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)


# -------------------------------------------------------------------
# Activity Start
# -------------------------------------------------------------------

func _on_start_review_button_pressed() -> void:
	if review_active:
		return

	start_manual_index_review()


func start_manual_index_review() -> void:
	active_review_cases.clear()

	for review_case: Dictionary in REVIEW_CASES:
		active_review_cases.append(
			review_case.duplicate(true)
		)

	active_review_cases.shuffle()

	while active_review_cases.size() > REVIEW_PAGE_COUNT:
		active_review_cases.remove_at(
			active_review_cases.size() - 1
		)

	current_review_index = 0
	correct_review_count = 0

	review_active = true
	review_completed = false
	
	manual_index_review_card.set_in_progress_state(
		"REVIEW IN PROGRESS"
	)

	accept_button.visible = true
	accept_button.disabled = false

	reject_button.visible = true
	reject_button.disabled = false

	close_review_button.visible = false
	close_review_button.disabled = true

	review_minimize_button.disabled = false

	review_window.visible = true
	minimized_review_button.visible = false

	review_feedback_label.text = (
		"Review each page using the rules above."
	)

	show_current_review_case()
	
func start_broken_link_cleanup() -> void:
	if cleanup_active:
		return

	cleanup_active = true
	cleanup_completed = false

	broken_link_cleanup_card.set_in_progress_state(
		"CLEANUP IN PROGRESS"
	)

	cleanup_answer_button_1.visible = true
	cleanup_answer_button_1.disabled = false

	cleanup_answer_button_2.visible = true
	cleanup_answer_button_2.disabled = false

	cleanup_answer_button_3.visible = true
	cleanup_answer_button_3.disabled = false

	cleanup_answer_button_4.visible = true
	cleanup_answer_button_4.disabled = false

	close_cleanup_button.visible = false
	close_cleanup_button.disabled = true

	cleanup_minimize_button.disabled = false

	cleanup_window.visible = true
	minimized_cleanup_button.visible = false

	cleanup_progress_label.text = (
		"RECORD 1 OF 5"
	)

	cleanup_url_label.text = (
		"URL: www.example99.com/downloads/"
		+ "video_driver_98.zip"
	)

	cleanup_link_data_label.text = (
		"Server Response: 404 - File Not Found\n"
		+ "Requested File: video_driver_98.zip"
	)

	cleanup_feedback_label.text = (
		"Select the best repair option."
	)

	cleanup_answer_button_1.text = "OPTION A"
	cleanup_answer_button_2.text = "OPTION B"
	cleanup_answer_button_3.text = "OPTION C"
	cleanup_answer_button_4.text = "OPTION D"
	
	
# -------------------------------------------------------------------
# Review Window State
# -------------------------------------------------------------------

func _on_review_minimize_button_pressed() -> void:
	if not review_active:
		return

	review_window.visible = false
	minimized_review_button.visible = true

	update_minimized_review_button()


func _on_minimized_review_button_pressed() -> void:
	if not review_active:
		minimized_review_button.visible = false
		return

	minimized_review_button.visible = false
	review_window.visible = true


func update_minimized_review_button() -> void:
	if not review_active:
		minimized_review_button.visible = false
		return

	var displayed_page: int = clampi(
		current_review_index + 1,
		1,
		REVIEW_PAGE_COUNT
	)

	minimized_review_button.text = (
		"Manual Index Review — %d/%d"
		% [
			displayed_page,
			REVIEW_PAGE_COUNT
		]
	)
	
	
# -------------------------------------------------------------------
# Broken Link Cleanup Window State
# -------------------------------------------------------------------

func _on_cleanup_minimize_button_pressed() -> void:
	if not cleanup_active:
		return

	cleanup_window.visible = false
	minimized_cleanup_button.visible = true

	update_minimized_cleanup_button()


func _on_minimized_cleanup_button_pressed() -> void:
	if not cleanup_active:
		minimized_cleanup_button.visible = false
		return

	minimized_cleanup_button.visible = false
	cleanup_window.visible = true


func update_minimized_cleanup_button() -> void:
	if not cleanup_active:
		minimized_cleanup_button.visible = false
		return

	minimized_cleanup_button.text = (
		"Broken Link Cleanup — 1/5"
	)
	
func _on_close_cleanup_button_pressed() -> void:
	if not cleanup_completed:
		return

	close_broken_link_cleanup()


func close_broken_link_cleanup() -> void:
	cleanup_window.visible = false
	minimized_cleanup_button.visible = false

	cleanup_active = false
	cleanup_completed = false

	close_cleanup_button.visible = false
	close_cleanup_button.disabled = true

	cleanup_answer_button_1.visible = true
	cleanup_answer_button_1.disabled = false

	cleanup_answer_button_2.visible = true
	cleanup_answer_button_2.disabled = false

	cleanup_answer_button_3.visible = true
	cleanup_answer_button_3.disabled = false

	cleanup_answer_button_4.visible = true
	cleanup_answer_button_4.disabled = false

	cleanup_minimize_button.disabled = false

	broken_link_cleanup_card.set_available_state(
		"START ANOTHER CLEANUP"
	)


# -------------------------------------------------------------------
# Review Display
# -------------------------------------------------------------------

func show_current_review_case() -> void:
	if not review_active:
		return

	if current_review_index >= active_review_cases.size():
		complete_manual_index_review()
		return

	var review_case: Dictionary = (
		active_review_cases[current_review_index]
	)

	review_progress_label.text = (
		"PAGE %d OF %d"
		% [
			current_review_index + 1,
			REVIEW_PAGE_COUNT
		]
	)
	
	update_minimized_review_button()

	review_url_label.text = (
		"URL: %s"
		% str(
			review_case.get(
				"url",
				"Unknown"
			)
		)
	)

	var duplicate_text: String = (
		"YES"
		if bool(
			review_case.get(
				"duplicate",
				false
			)
		)
		else "NO"
	)

	var spam_text: String = (
		"YES"
		if bool(
			review_case.get(
				"spam",
				false
			)
		)
		else "NO"
	)

	review_data_label.text = (
		"HTTP Status: %d\n"
		+ "Content Size: %.1f KB\n"
		+ "Duplicate: %s\n"
		+ "Spam Flag: %s"
	) % [
		int(
			review_case.get(
				"status_code",
				0
			)
		),
		float(
			review_case.get(
				"content_size_kb",
				0.0
			)
		),
		duplicate_text,
		spam_text
	]
	
func apply_review_window_bottom_theme() -> void:
	var feedback_style: StyleBoxFlat = StyleBoxFlat.new()

	feedback_style.bg_color = (
		REVIEW_FEEDBACK_BACKGROUND_COLOR
	)

	feedback_style.border_color = (
		REVIEW_FEEDBACK_BORDER_COLOR
	)

	feedback_style.border_width_left = 1
	feedback_style.border_width_top = 1
	feedback_style.border_width_right = 1
	feedback_style.border_width_bottom = 1

	review_feedback_panel.add_theme_stylebox_override(
		"panel",
		feedback_style
	)

	apply_review_action_button_style(
		accept_button,
		REVIEW_ACCEPT_HOVER_COLOR
	)

	apply_review_action_button_style(
		reject_button,
		REVIEW_REJECT_HOVER_COLOR
	)

	apply_review_action_button_style(
		close_review_button,
		REVIEW_CLOSE_HOVER_COLOR
	)
	
func apply_cleanup_window_bottom_theme() -> void:
	var feedback_style: StyleBoxFlat = StyleBoxFlat.new()

	feedback_style.bg_color = (
		REVIEW_FEEDBACK_BACKGROUND_COLOR
	)

	feedback_style.border_color = (
		REVIEW_FEEDBACK_BORDER_COLOR
	)

	feedback_style.border_width_left = 1
	feedback_style.border_width_top = 1
	feedback_style.border_width_right = 1
	feedback_style.border_width_bottom = 1

	cleanup_feedback_panel.add_theme_stylebox_override(
		"panel",
		feedback_style
	)

	apply_review_action_button_style(
		cleanup_answer_button_1,
		REVIEW_CLOSE_HOVER_COLOR
	)

	apply_review_action_button_style(
		cleanup_answer_button_2,
		REVIEW_CLOSE_HOVER_COLOR
	)

	apply_review_action_button_style(
		cleanup_answer_button_3,
		REVIEW_CLOSE_HOVER_COLOR
	)

	apply_review_action_button_style(
		cleanup_answer_button_4,
		REVIEW_CLOSE_HOVER_COLOR
	)

	apply_review_action_button_style(
		close_cleanup_button,
		REVIEW_CLOSE_HOVER_COLOR
	)
	
func apply_review_action_button_style(
	button: Button,
	hover_color: Color
) -> void:
	var normal_style: StyleBoxFlat = StyleBoxFlat.new()

	normal_style.bg_color = (
		REVIEW_BUTTON_NORMAL_COLOR
	)

	normal_style.border_color = Color("#707070")

	normal_style.border_width_left = 1
	normal_style.border_width_top = 1
	normal_style.border_width_right = 1
	normal_style.border_width_bottom = 1

	var hover_style: StyleBoxFlat = (
		normal_style.duplicate() as StyleBoxFlat
	)

	hover_style.bg_color = hover_color

	var pressed_style: StyleBoxFlat = (
		normal_style.duplicate() as StyleBoxFlat
	)

	pressed_style.bg_color = (
		REVIEW_BUTTON_PRESSED_COLOR
	)

	var disabled_style: StyleBoxFlat = (
		normal_style.duplicate() as StyleBoxFlat
	)

	disabled_style.bg_color = Color("#BEBEBE")

	button.add_theme_stylebox_override(
		"normal",
		normal_style
	)

	button.add_theme_stylebox_override(
		"hover",
		hover_style
	)

	button.add_theme_stylebox_override(
		"pressed",
		pressed_style
	)

	button.add_theme_stylebox_override(
		"disabled",
		disabled_style
	)

	button.add_theme_color_override(
		"font_color",
		REVIEW_WINDOW_TEXT_COLOR
	)

	button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_LIGHT
	)

	button.add_theme_color_override(
		"font_pressed_color",
		REVIEW_WINDOW_TEXT_COLOR
	)

	button.add_theme_color_override(
		"font_disabled_color",
		REVIEW_WINDOW_DISABLED_TEXT_COLOR
	)


# -------------------------------------------------------------------
# Decisions
# -------------------------------------------------------------------

func _on_accept_button_pressed() -> void:
	submit_review_decision(
		true
	)


func _on_reject_button_pressed() -> void:
	submit_review_decision(
		false
	)


func submit_review_decision(
	player_accepts: bool
) -> void:
	if not review_active:
		return

	if current_review_index >= active_review_cases.size():
		return

	var review_case: Dictionary = (
		active_review_cases[current_review_index]
	)

	var correct_answer: bool = bool(
		review_case.get(
			"should_accept",
			false
		)
	)

	if player_accepts == correct_answer:
		correct_review_count += 1

	current_review_index += 1

	show_current_review_case()


# -------------------------------------------------------------------
# Completion
# -------------------------------------------------------------------

func complete_manual_index_review() -> void:
	review_active = false
	review_completed = true
	
	ActivityStatsManager.record_completion(
		ACTIVITY_MANUAL_INDEX_REVIEW
	)

	manual_index_review_card.set_completion_count(
		ActivityStatsManager.get_type_completed(
			ACTIVITY_MANUAL_INDEX_REVIEW
		)
	)
	
	manual_index_review_card.set_completed_state(
		"RESULTS OPEN"
	)

	accept_button.disabled = true
	reject_button.disabled = true

	var money_reward: float = (
		float(correct_review_count)
		* MONEY_REWARD_PER_CORRECT
	)

	GameState.set_revenue(
		GameState.revenue
		+ money_reward
	)

	var perfect_review: bool = (
		correct_review_count
		>= REVIEW_PAGE_COUNT
	)

	var research_reward: float = 0.0

	if perfect_review:
		research_reward = (
			PERFECT_REVIEW_RESEARCH_REWARD
		)

		ResearchManager.add_research_points(
			PERFECT_REVIEW_RESEARCH_REWARD
		)

	review_progress_label.text = (
		"REVIEW COMPLETE"
	)

	review_url_label.text = (
		"RESULTS"
	)

	review_data_label.text = (
		"Correct Reviews: %d / %d\n"
		+ "Revenue Earned: $%.0f\n"
		+ "Research Earned: +%.0f RP"
	) % [
		correct_review_count,
		REVIEW_PAGE_COUNT,
		money_reward,
		research_reward
	]

	if perfect_review:
		review_feedback_label.text = (
			"PERFECT REVIEW — All pages were classified correctly."
		)

	else:
		review_feedback_label.text = (
			"REVIEW COMPLETE — %d of %d pages classified correctly."
			% [
				correct_review_count,
				REVIEW_PAGE_COUNT
			]
		)

	accept_button.visible = false
	reject_button.visible = false

	close_review_button.visible = true
	close_review_button.disabled = false

	review_minimize_button.disabled = true

	minimized_review_button.visible = false
	
	
func _on_close_review_button_pressed() -> void:
	if not review_completed:
		return

	close_manual_index_review()
	
func close_manual_index_review() -> void:
	review_window.visible = false
	minimized_review_button.visible = false

	review_active = false
	review_completed = false

	active_review_cases.clear()

	current_review_index = 0
	correct_review_count = 0

	close_review_button.visible = false
	close_review_button.disabled = true

	accept_button.visible = true
	accept_button.disabled = false

	reject_button.visible = true
	reject_button.disabled = false

	review_minimize_button.disabled = false
	
	manual_index_review_card.set_available_state(
		"START ANOTHER REVIEW"
	)
