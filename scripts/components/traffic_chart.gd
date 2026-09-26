extends Control

class_name TrafficChart


# -------------------------------------------------------------------
# Chart Settings
# -------------------------------------------------------------------

const GRID_DIVISIONS_X: int = 4
const GRID_DIVISIONS_Y: int = 3

const CHART_PADDING_LEFT: float = 4.0
const CHART_PADDING_RIGHT: float = 4.0
const CHART_PADDING_TOP: float = 4.0
const CHART_PADDING_BOTTOM: float = 4.0

const TRAFFIC_LINE_WIDTH: float = 2.0


# -------------------------------------------------------------------
# Traffic Data
# -------------------------------------------------------------------

var incoming_traffic: Array[float] = []
var outgoing_traffic: Array[float] = []


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	if not resized.is_connected(
		_on_chart_resized
	):
		resized.connect(
			_on_chart_resized
		)

	tooltip_text = (
		"24-Hour Traffic Trend\n\n"
		+ "Blue: Incoming traffic\n"
		+ "Green: Outgoing traffic"
	)

	queue_redraw()


func _on_chart_resized() -> void:
	queue_redraw()


# -------------------------------------------------------------------
# Traffic Data
# -------------------------------------------------------------------

func set_traffic_data(
	new_incoming_traffic: Array[float],
	new_outgoing_traffic: Array[float]
) -> void:
	incoming_traffic = (
		new_incoming_traffic.duplicate()
	)

	outgoing_traffic = (
		new_outgoing_traffic.duplicate()
	)

	queue_redraw()


func create_preview_data() -> void:
	incoming_traffic.clear()
	outgoing_traffic.clear()

	for hour_index: int in range(24):
		var hour_value: float = float(
			hour_index
		)

		var incoming_value: float = (
			28.0
			+ sin(hour_value * 0.48) * 9.0
			+ sin(hour_value * 0.17) * 5.0
		)

		var outgoing_value: float = (
			22.0
			+ sin(
				hour_value * 0.48
				+ 0.65
			) * 7.0
			+ sin(hour_value * 0.20) * 4.0
		)

		incoming_traffic.append(
			maxf(
				incoming_value,
				1.0
			)
		)

		outgoing_traffic.append(
			maxf(
				outgoing_value,
				1.0
			)
		)


# -------------------------------------------------------------------
# Drawing
# -------------------------------------------------------------------

func _draw() -> void:
	var chart_rect: Rect2 = get_chart_rect()

	if (
		chart_rect.size.x <= 1.0
		or chart_rect.size.y <= 1.0
	):
		return

	draw_chart_grid(
		chart_rect
	)

	var maximum_value: float = (
		get_maximum_traffic_value()
	)

	draw_traffic_series(
		incoming_traffic,
		chart_rect,
		maximum_value,
		ThemeManager.CHART_LINE_BLUE
	)

	draw_traffic_series(
		outgoing_traffic,
		chart_rect,
		maximum_value,
		ThemeManager.CHART_LINE_GREEN
	)


func get_chart_rect() -> Rect2:
	var chart_width: float = maxf(
		size.x
		- CHART_PADDING_LEFT
		- CHART_PADDING_RIGHT,
		0.0
	)

	var chart_height: float = maxf(
		size.y
		- CHART_PADDING_TOP
		- CHART_PADDING_BOTTOM,
		0.0
	)

	return Rect2(
		Vector2(
			CHART_PADDING_LEFT,
			CHART_PADDING_TOP
		),
		Vector2(
			chart_width,
			chart_height
		)
	)


func draw_chart_grid(
	chart_rect: Rect2
) -> void:
	for division_index: int in range(
		GRID_DIVISIONS_X + 1
	):
		var division_ratio: float = (
			float(division_index)
			/ float(GRID_DIVISIONS_X)
		)

		var line_x: float = (
			chart_rect.position.x
			+ chart_rect.size.x
			* division_ratio
		)

		draw_line(
			Vector2(
				line_x,
				chart_rect.position.y
			),
			Vector2(
				line_x,
				chart_rect.position.y
				+ chart_rect.size.y
			),
			ThemeManager.CHART_GRID,
			1.0
		)

	for division_index: int in range(
		GRID_DIVISIONS_Y + 1
	):
		var division_ratio: float = (
			float(division_index)
			/ float(GRID_DIVISIONS_Y)
		)

		var line_y: float = (
			chart_rect.position.y
			+ chart_rect.size.y
			* division_ratio
		)

		draw_line(
			Vector2(
				chart_rect.position.x,
				line_y
			),
			Vector2(
				chart_rect.position.x
				+ chart_rect.size.x,
				line_y
			),
			ThemeManager.CHART_GRID,
			1.0
		)


func draw_traffic_series(
	traffic_values: Array[float],
	chart_rect: Rect2,
	maximum_value: float,
	line_color: Color
) -> void:
	if traffic_values.size() < 2:
		return

	var points: PackedVector2Array = (
		PackedVector2Array()
	)

	for value_index: int in range(
		traffic_values.size()
	):
		var horizontal_ratio: float = (
			float(value_index)
			/ float(
				traffic_values.size() - 1
			)
		)

		var safe_value: float = maxf(
			traffic_values[value_index],
			0.0
		)

		var vertical_ratio: float = clampf(
			safe_value
			/ maximum_value,
			0.0,
			1.0
		)

		var point_x: float = (
			chart_rect.position.x
			+ chart_rect.size.x
			* horizontal_ratio
		)

		var point_y: float = (
			chart_rect.position.y
			+ chart_rect.size.y
			- chart_rect.size.y
			* vertical_ratio
		)

		points.append(
			Vector2(
				point_x,
				point_y
			)
		)

	draw_polyline(
		points,
		line_color,
		TRAFFIC_LINE_WIDTH,
		false
	)


func get_maximum_traffic_value() -> float:
	var maximum_value: float = 1.0

	for traffic_value: float in incoming_traffic:
		maximum_value = maxf(
			maximum_value,
			traffic_value
		)

	for traffic_value: float in outgoing_traffic:
		maximum_value = maxf(
			maximum_value,
			traffic_value
		)

	return maximum_value * 1.10
