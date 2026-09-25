class_name ActivityCard
extends PanelContainer


signal start_requested(
	activity_id: StringName
)


# -------------------------------------------------------------------
# Card Colors
# -------------------------------------------------------------------

const CARD_BACKGROUND_COLOR: Color = Color("#D4D0C8")
const CARD_BORDER_COLOR: Color = Color("#808080")


# -------------------------------------------------------------------
# Card State
# -------------------------------------------------------------------

var activity_id: StringName = &""


# -------------------------------------------------------------------
# Node References
# -------------------------------------------------------------------

@onready var title_label: Label = (
	$CardMargin/CardLayout/HeaderRow/TitleLabel
)

@onready var status_label: Label = (
	$CardMargin/CardLayout/HeaderRow/StatusLabel
)

@onready var description_label: Label = (
	$CardMargin/CardLayout/DescriptionLabel
)

@onready var time_label: Label = (
	$CardMargin/CardLayout/InfoRow/TimeLabel
)

@onready var reward_label: Label = (
	$CardMargin/CardLayout/InfoRow/RewardLabel
)

@onready var completion_label: Label = (
	$CardMargin/CardLayout/InfoRow/CompletionLabel
)

@onready var start_button: Button = (
	$CardMargin/CardLayout/StartButton
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	apply_card_theme()

	if not start_button.pressed.is_connected(
		_on_start_button_pressed
	):
		start_button.pressed.connect(
			_on_start_button_pressed
		)


# -------------------------------------------------------------------
# Configuration
# -------------------------------------------------------------------

func configure(
	new_activity_id: StringName,
	title: String,
	description: String,
	time_text: String,
	reward_text: String,
	button_text: String = "START"
) -> void:
	activity_id = new_activity_id

	title_label.text = title
	description_label.text = description

	time_label.text = (
		"TIME: " + time_text
	)

	reward_label.text = (
		"REWARD: " + reward_text
	)

	start_button.text = button_text

	set_available_state()
	set_completion_count(0)


func set_completion_count(
	completion_count: int
) -> void:
	completion_label.text = (
		"DONE: %d"
		% maxi(completion_count, 0)
	)


# -------------------------------------------------------------------
# Card States
# -------------------------------------------------------------------

func set_available_state(
	button_text: String = "START"
) -> void:
	status_label.text = "AVAILABLE"

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	start_button.text = button_text
	start_button.disabled = false


func set_in_progress_state(
	button_text: String = "IN PROGRESS"
) -> void:
	status_label.text = "IN PROGRESS"

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_WARNING
	)

	start_button.text = button_text
	start_button.disabled = true
	
func set_completed_state(
	button_text: String = "START AGAIN"
) -> void:
	status_label.text = "COMPLETE"

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_SUCCESS
	)

	start_button.text = button_text
	start_button.disabled = true


func set_locked_state(
	lock_text: String = "LOCKED"
) -> void:
	status_label.text = lock_text

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	start_button.disabled = true



# -------------------------------------------------------------------
# Theme
# -------------------------------------------------------------------

func apply_card_theme() -> void:
	var card_style: StyleBoxFlat = StyleBoxFlat.new()

	card_style.bg_color = CARD_BACKGROUND_COLOR
	card_style.border_color = CARD_BORDER_COLOR

	card_style.border_width_left = 1
	card_style.border_width_top = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1

	add_theme_stylebox_override(
		"panel",
		card_style
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.ACCENT_BLUE
	)

	title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	description_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	time_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	reward_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	completion_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	start_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	start_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	start_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)

	start_button.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	start_button.add_theme_color_override(
		"font_hover_color",
		ThemeManager.TEXT_PRIMARY
	)

	start_button.add_theme_color_override(
		"font_pressed_color",
		ThemeManager.TEXT_LIGHT
	)


# -------------------------------------------------------------------
# Button
# -------------------------------------------------------------------

func _on_start_button_pressed() -> void:
	if activity_id == &"":
		return

	start_requested.emit(
		activity_id
	)
