extends Control


# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------

@onready var tutorial_window: PanelContainer = (
	$TutorialWindow
)

@onready var tutorial_header: Label = (
	$TutorialWindow/TutorialMargin
	/TutorialLayout/TutorialHeader
)

@onready var step_label: Label = (
	$TutorialWindow/TutorialMargin
	/TutorialLayout/StepLabel
)

@onready var tutorial_body: Label = (
	$TutorialWindow/TutorialMargin
	/TutorialLayout/TutorialBody
)

@onready var skip_button: Button = (
	$TutorialWindow/TutorialMargin
	/TutorialLayout/TutorialButtons
	/SkipButton
)

@onready var next_button: Button = (
	$TutorialWindow/TutorialMargin
	/TutorialLayout/TutorialButtons
	/NextButton
)

@onready var tutorial_focus_frame: Panel = (
	$TutorialFocusFrame
)

# -------------------------------------------------------------------
# Tutorial focus
# -------------------------------------------------------------------

const FOCUS_PADDING: float = 4.0

const CRAWLER_FOCUS_BOTTOM_TRIM: float = 6.0

var focus_target: Control = null
var focus_tween: Tween = null
var focus_step_id: StringName = &""


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	configure_tutorial_window()
	configure_tutorial_focus()

	apply_tutorial_theme()
	connect_tutorial_signals()
	connect_tutorial_buttons()

	tutorial_window.visible = false
	tutorial_focus_frame.visible = false




# -------------------------------------------------------------------
# Window layout
# -------------------------------------------------------------------

func configure_tutorial_window() -> void:
	tutorial_window.anchor_left = 1.0
	tutorial_window.anchor_top = 0.0
	tutorial_window.anchor_right = 1.0
	tutorial_window.anchor_bottom = 0.0

	tutorial_window.offset_left = -440.0
	tutorial_window.offset_top = 60.0
	tutorial_window.offset_right = -20.0
	tutorial_window.offset_bottom = 260.0

	tutorial_window.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
func configure_tutorial_focus() -> void:
	tutorial_focus_frame.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	var focus_style: StyleBoxFlat = (
		StyleBoxFlat.new()
	)

	focus_style.bg_color = Color(
		0.0,
		0.0,
		0.0,
		0.0
	)

	focus_style.border_color = (
		ThemeManager.STATUS_WARNING
	)

	focus_style.border_width_left = 2
	focus_style.border_width_top = 2
	focus_style.border_width_right = 2
	focus_style.border_width_bottom = 2

	tutorial_focus_frame.add_theme_stylebox_override(
		"panel",
		focus_style
	)


# -------------------------------------------------------------------
# Theme
# -------------------------------------------------------------------

func apply_tutorial_theme() -> void:
	tutorial_window.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_job_indicator_style()
	)

	tutorial_header.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	tutorial_header.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	step_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	step_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	tutorial_body.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	tutorial_body.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

func connect_tutorial_signals() -> void:
	if not TutorialManager.tutorial_started.is_connected(
		_on_tutorial_started
	):
		TutorialManager.tutorial_started.connect(
			_on_tutorial_started
		)

	if not TutorialManager.tutorial_step_changed.is_connected(
		_on_tutorial_step_changed
	):
		TutorialManager.tutorial_step_changed.connect(
			_on_tutorial_step_changed
		)

	if not TutorialManager.tutorial_completed.is_connected(
		_on_tutorial_completed
	):
		TutorialManager.tutorial_completed.connect(
			_on_tutorial_completed
		)

	if not TutorialManager.tutorial_skipped.is_connected(
		_on_tutorial_skipped
	):
		TutorialManager.tutorial_skipped.connect(
			_on_tutorial_skipped
		)


func connect_tutorial_buttons() -> void:
	if not next_button.pressed.is_connected(
		_on_next_button_pressed
	):
		next_button.pressed.connect(
			_on_next_button_pressed
		)

	if not skip_button.pressed.is_connected(
		_on_skip_button_pressed
	):
		skip_button.pressed.connect(
			_on_skip_button_pressed
		)


# -------------------------------------------------------------------
# Tutorial display
# -------------------------------------------------------------------

func _on_tutorial_started() -> void:
	tutorial_window.visible = true


func _on_tutorial_step_changed(
	_step_id: StringName,
	title: String,
	message: String
) -> void:
	tutorial_window.visible = true
	
	update_tutorial_focus(
		_step_id
	)

	tutorial_header.text = title
	tutorial_body.text = message

	step_label.text = (
		"STEP %d OF %d"
		% [
			TutorialManager.get_current_step_number(),
			TutorialManager.get_total_step_count()
		]
	)

	if TutorialManager.current_step_requires_action():
		next_button.text = "Waiting for Action..."
		next_button.disabled = true

	elif TutorialManager.is_last_step():
		next_button.text = "Finish"
		next_button.disabled = false

	else:
		next_button.text = "Next >"
		next_button.disabled = false


func _on_tutorial_completed() -> void:
	tutorial_window.visible = false
	
	hide_tutorial_focus()


func _on_tutorial_skipped() -> void:
	tutorial_window.visible = false
	
	hide_tutorial_focus()
	
	
# -------------------------------------------------------------------
# Focus targets
# -------------------------------------------------------------------

func get_focus_target_for_step(
	step_id: StringName
) -> Control:
	var main_scene: Node = (
		get_tree().current_scene
	)

	if main_scene == null:
		return null

	match step_id:
		TutorialManager.STEP_RESOURCES:
			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "ResourceBar"
			) as Control

		TutorialManager.STEP_CRAWLER:
			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "TabBar/TabRow/CrawlerTab"
			) as Control

		TutorialManager.STEP_SERVER_LOAD:
			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "ResourceBar/ResourceRow/"
				+ "ServerLoadDisplay"
			) as Control
			
		TutorialManager.STEP_OBJECTIVES:
			if (
				TutorialManager.current_page_id
				== &"dashboard"
			):
				return main_scene.find_child(
					"CurrentObjectivePanel",
					true,
					false
				) as Control

			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "TabBar/TabRow/DashboardTab"
			) as Control

		TutorialManager.STEP_RESEARCH:
			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "TabBar/TabRow/ResearchTab"
			) as Control

		TutorialManager.STEP_SERVERS:
			return main_scene.get_node_or_null(
				"MainApplicationWindow/MainLayout/"
				+ "TabBar/TabRow/ServersTab"
			) as Control

	return null
	
func update_tutorial_focus(
	step_id: StringName
) -> void:
	hide_tutorial_focus()

	focus_step_id = step_id

	focus_target = get_focus_target_for_step(
		step_id
	)

	if focus_target == null:
		return

	tutorial_focus_frame.visible = true

	update_focus_frame_position()
	start_focus_pulse()

func update_focus_frame_position() -> void:
	if focus_target == null:
		return

	if not is_instance_valid(
		focus_target
	):
		return

	var target_rect: Rect2 = (
		focus_target.get_global_rect()
	)

	var overlay_rect: Rect2 = (
		get_global_rect()
	)

	var padding_vector: Vector2 = Vector2(
		FOCUS_PADDING,
		FOCUS_PADDING
	)

	var focus_position: Vector2 = (
		target_rect.position
		- overlay_rect.position
		- padding_vector
	)

	var focus_size: Vector2 = (
		target_rect.size
		+ padding_vector * 2.0
	)

	if focus_step_id == TutorialManager.STEP_CRAWLER:
		focus_size.y -= (
			CRAWLER_FOCUS_BOTTOM_TRIM
		)

	tutorial_focus_frame.position = (
		focus_position
	)

	tutorial_focus_frame.size = (
		focus_size
	)
	
func start_focus_pulse() -> void:
	if (
		focus_tween != null
		and focus_tween.is_valid()
	):
		focus_tween.kill()

	tutorial_focus_frame.modulate.a = 1.0

	focus_tween = create_tween()

	focus_tween.set_loops()

	focus_tween.tween_property(
		tutorial_focus_frame,
		"modulate:a",
		0.4,
		0.55
	)

	focus_tween.tween_property(
		tutorial_focus_frame,
		"modulate:a",
		1.0,
		0.55
	)
	
func hide_tutorial_focus() -> void:
	focus_step_id = &""
	if (
		focus_tween != null
		and focus_tween.is_valid()
	):
		focus_tween.kill()

	focus_tween = null
	focus_target = null

	tutorial_focus_frame.visible = false
	tutorial_focus_frame.modulate.a = 1.0
	
func _process(
	_delta: float
) -> void:
	if not tutorial_focus_frame.visible:
		return

	if focus_target == null:
		return

	update_focus_frame_position()

# -------------------------------------------------------------------
# Buttons
# -------------------------------------------------------------------

func _on_next_button_pressed() -> void:
	TutorialManager.advance_step()


func _on_skip_button_pressed() -> void:
	TutorialManager.skip_tutorial()
