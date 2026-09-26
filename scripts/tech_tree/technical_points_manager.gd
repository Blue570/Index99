extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal technical_points_changed(
	new_points: int
)

signal technical_points_awarded(
	amount: int,
	source: String
)

signal technical_points_spent(
	amount: int,
	source: String
)


# -------------------------------------------------------------------
# Technical Points
# -------------------------------------------------------------------

var technical_points: int = 0


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	print(
		"TechnicalPointsManager: Ready with %d TP."
		% technical_points
	)


# -------------------------------------------------------------------
# Point Management
# -------------------------------------------------------------------

func get_technical_points() -> int:
	return technical_points


func set_technical_points(
	new_value: int
) -> void:
	var safe_value: int = maxi(
		new_value,
		0
	)

	if technical_points == safe_value:
		return

	technical_points = safe_value

	technical_points_changed.emit(
		technical_points
	)


func award_technical_points(
	amount: int,
	source: String = ""
) -> bool:
	if amount <= 0:
		return false

	set_technical_points(
		technical_points + amount
	)

	technical_points_awarded.emit(
		amount,
		source
	)

	return true


func can_afford_technical_points(
	amount: int
) -> bool:
	if amount < 0:
		return false

	return technical_points >= amount


func spend_technical_points(
	amount: int,
	source: String = ""
) -> bool:
	if amount <= 0:
		return false

	if not can_afford_technical_points(
		amount
	):
		return false

	set_technical_points(
		technical_points - amount
	)

	technical_points_spent.emit(
		amount,
		source
	)

	return true


# -------------------------------------------------------------------
# Save Data
# -------------------------------------------------------------------

func get_save_data() -> Dictionary:
	return {
		"technical_points": technical_points
	}


func restore_saved_state(
	data: Dictionary
) -> void:
	set_technical_points(
		int(
			data.get(
				"technical_points",
				0
			)
		)
	)

	print(
		"TechnicalPointsManager: "
		+ "Restored %d TP."
		% technical_points
	)


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_technical_points() -> void:
	set_technical_points(
		0
	)
	
# -------------------------------------------------------------------
# Debug Testing
# -------------------------------------------------------------------

func _input(
	event: InputEvent
) -> void:
	if not OS.is_debug_build():
		return

	if not event is InputEventKey:
		return

	var key_event: InputEventKey = (
		event as InputEventKey
	)

	if not key_event.pressed:
		return

	if key_event.echo:
		return

	if (
		key_event.keycode == KEY_F11
		and key_event.ctrl_pressed
		and key_event.shift_pressed
	):
		award_technical_points(
			5,
			"Debug Test"
		)

		print(
			"TechnicalPointsManager: "
			+ "Debug award -> %d TP."
			% technical_points
		)
