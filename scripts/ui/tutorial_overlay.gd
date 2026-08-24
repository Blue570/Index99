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


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	configure_tutorial_window()
	apply_tutorial_theme()
	connect_tutorial_signals()
	connect_tutorial_buttons()

	tutorial_window.visible = false




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


func _on_tutorial_skipped() -> void:
	tutorial_window.visible = false


# -------------------------------------------------------------------
# Buttons
# -------------------------------------------------------------------

func _on_next_button_pressed() -> void:
	TutorialManager.advance_step()


func _on_skip_button_pressed() -> void:
	TutorialManager.skip_tutorial()
