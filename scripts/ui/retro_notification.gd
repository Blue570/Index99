extends PanelContainer


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal dismissed


# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------

@onready var notification_header: PanelContainer = (
	$NotificationLayout/NotificationHeader
)

@onready var type_label: Label = (
	$NotificationLayout/NotificationHeader
	/HeaderMargin/HeaderRow/TypeLabel
)

@onready var close_button: Button = (
	$NotificationLayout/NotificationHeader
	/HeaderMargin/HeaderRow/CloseButton
)

@onready var title_label: Label = (
	$NotificationLayout/BodyMargin
	/BodyLayout/TitleLabel
)

@onready var message_label: Label = (
	$NotificationLayout/BodyMargin
	/BodyLayout/MessageLabel
)


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var lifetime_timer: Timer


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	create_lifetime_timer()
	apply_base_theme()

	if not close_button.pressed.is_connected(
		_on_close_button_pressed
	):
		close_button.pressed.connect(
			_on_close_button_pressed
		)


func create_lifetime_timer() -> void:
	lifetime_timer = Timer.new()

	lifetime_timer.name = (
		"NotificationLifetimeTimer"
	)

	lifetime_timer.one_shot = true
	lifetime_timer.autostart = false

	add_child(
		lifetime_timer
	)

	lifetime_timer.timeout.connect(
		_on_lifetime_timer_timeout
	)


# -------------------------------------------------------------------
# Configure notification
# -------------------------------------------------------------------

func configure(
	title: String,
	message: String,
	notification_type: StringName,
	duration: float
) -> void:
	title_label.text = title
	message_label.text = message

	type_label.text = (
		get_type_text(
			notification_type
		)
	)

	apply_notification_type(
		notification_type
	)

	lifetime_timer.start(
		maxf(
			duration,
			1.0
		)
	)


# -------------------------------------------------------------------
# Theme
# -------------------------------------------------------------------

func apply_base_theme() -> void:
	add_theme_stylebox_override(
		"panel",
		ThemeManager.create_job_indicator_style()
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_NORMAL
	)

	message_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	message_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	type_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	close_button.add_theme_stylebox_override(
		"normal",
		ThemeManager.create_window_button_normal_style()
	)

	close_button.add_theme_stylebox_override(
		"hover",
		ThemeManager.create_window_button_hover_style()
	)

	close_button.add_theme_stylebox_override(
		"pressed",
		ThemeManager.create_window_button_pressed_style()
	)


func apply_notification_type(
	notification_type: StringName
) -> void:
	var type_color: Color = (
		get_type_color(
			notification_type
		)
	)

	var header_style: StyleBoxFlat = (
		StyleBoxFlat.new()
	)

	header_style.bg_color = type_color

	header_style.border_width_bottom = 1

	header_style.border_color = (
		ThemeManager.TITLE_BAR_BORDER
	)

	notification_header.add_theme_stylebox_override(
		"panel",
		header_style
	)

	type_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_LIGHT
	)


func get_type_color(
	notification_type: StringName
) -> Color:
	match notification_type:
		NotificationManager.TYPE_SUCCESS:
			return ThemeManager.STATUS_SUCCESS

		NotificationManager.TYPE_WARNING:
			return ThemeManager.STATUS_WARNING

		NotificationManager.TYPE_ERROR:
			return ThemeManager.STATUS_ERROR

		NotificationManager.TYPE_UNLOCK:
			return ThemeManager.ACCENT_BLUE

	return ThemeManager.STATUS_INFORMATION


func get_type_text(
	notification_type: StringName
) -> String:
	match notification_type:
		NotificationManager.TYPE_SUCCESS:
			return "SUCCESS"

		NotificationManager.TYPE_WARNING:
			return "WARNING"

		NotificationManager.TYPE_ERROR:
			return "ERROR"

		NotificationManager.TYPE_UNLOCK:
			return "UNLOCKED"

	return "INFORMATION"


# -------------------------------------------------------------------
# Close
# -------------------------------------------------------------------

func _on_close_button_pressed() -> void:
	dismiss_notification()


func _on_lifetime_timer_timeout() -> void:
	dismiss_notification()


func dismiss_notification() -> void:
	lifetime_timer.stop()

	dismissed.emit()
