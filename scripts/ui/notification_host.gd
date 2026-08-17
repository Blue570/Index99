extends Control


# -------------------------------------------------------------------
# Notification scene
# -------------------------------------------------------------------

const NOTIFICATION_SCENE: PackedScene = preload(
	"res://scenes/ui/retro_notification.tscn"
)


# -------------------------------------------------------------------
# Node references
# -------------------------------------------------------------------

@onready var notification_anchor: Control = (
	$NotificationAnchor
)


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var active_notification: Control = null


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	configure_notification_anchor()

	if not NotificationManager.notification_queued.is_connected(
		_on_notification_queued
	):
		NotificationManager.notification_queued.connect(
			_on_notification_queued
		)

	call_deferred(
		"show_next_notification"
	)
	
func configure_notification_anchor() -> void:
	notification_anchor.anchor_left = 1.0
	notification_anchor.anchor_top = 1.0
	notification_anchor.anchor_right = 1.0
	notification_anchor.anchor_bottom = 1.0

	notification_anchor.offset_left = -380.0
	notification_anchor.offset_top = -225.0
	notification_anchor.offset_right = -20.0
	notification_anchor.offset_bottom = -90.0


# -------------------------------------------------------------------
# Queue
# -------------------------------------------------------------------

func _on_notification_queued() -> void:
	show_next_notification()


func show_next_notification() -> void:
	if active_notification != null:
		return

	if not NotificationManager.has_pending_notifications():
		return

	var notification_data: Dictionary = (
		NotificationManager.take_next_notification()
	)

	if notification_data.is_empty():
		return

	var notification_instance: Control = (
		NOTIFICATION_SCENE.instantiate()
		as Control
	)

	if notification_instance == null:
		push_error(
			"NotificationHost: Could not instantiate notification."
		)
		return

	notification_anchor.add_child(
		notification_instance
	)

	notification_instance.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	active_notification = notification_instance

	if notification_instance.has_signal(
		"dismissed"
	):
		notification_instance.connect(
			"dismissed",
			_on_notification_dismissed
		)

	var notification_type: StringName = StringName(
		notification_data.get(
			"type",
			NotificationManager.TYPE_INFORMATION
		)
	)

	notification_instance.call(
		"configure",
		str(
			notification_data.get(
				"title",
				"NOTIFICATION"
			)
		),
		str(
			notification_data.get(
				"message",
				""
			)
		),
		notification_type,
		float(
			notification_data.get(
				"duration",
				NotificationManager.DEFAULT_DURATION_SECONDS
			)
		)
	)


# -------------------------------------------------------------------
# Dismiss
# -------------------------------------------------------------------

func _on_notification_dismissed() -> void:
	if active_notification == null:
		return

	active_notification.queue_free()
	active_notification = null

	call_deferred(
		"show_next_notification"
	)
