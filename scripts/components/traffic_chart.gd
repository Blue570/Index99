extends Control

class_name TrafficChart


# -------------------------------------------------------------------
# Chart Settings
# -------------------------------------------------------------------

const GRID_DIVISIONS_X: int = 4
const GRID_DIVISIONS_Y: int = 3

const CHART_PADDING_LEFT: float = 4.0
const CHART_PADDING_RIGHT: float = 4.0
const CHART_PADDING_TOP: float = 13.0
const CHART_PADDING_BOTTOM: float = 11.0

const TRAFFIC_LINE_WIDTH: float = 2.0

const STATUS_FONT_SIZE: int = 8
const TIME_FONT_SIZE: int = 7


# -------------------------------------------------------------------
# Traffic Data
# -------------------------------------------------------------------

var incoming_traffic: Array[float] = []
var outgoing_traffic: Array[float] = []


# -------------------------------------------------------------------
# Display Nodes
# -------------------------------------------------------------------

var status_row: HBoxContainer

var incoming_status_label: Label
var outgoing_status_label: Label

var time_row: HBoxContainer

var oldest_time_label: Label
var middle_time_label: Label
var newest_time_label: Label


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	build_status_display()
	build_time_display()

	if not resized.is_connected(
		_on_chart_resized
	):
		resized.connect(
			_on_chart_resized
		)

	tooltip_text = (
		"24-Hour Traffic Trend\n\n"
		+ "Blue: Incoming traffic\n"
		+ "Green: Outgoing traffic\n\n"
		+ "Traffic responds to active users, crawler activity, "
		+ "and crawler processing rate."
	)

	refresh_chart_labels()

	queue_redraw()


func _on_chart_resized() -> void:
	queue_redraw()


# -------------------------------------------------------------------
# Display Construction
# -------------------------------------------------------------------

func build_status_display() -> void:
	status_row = HBoxContainer.new()

	status_row.name = "TrafficStatusRow"

	status_row.set_anchors_preset(
		Control.PRESET_TOP_WIDE
	)

	status_row.offset_left = 4.0
	status_row.offset_top = 0.0
	status_row.offset_right = -4.0
	status_row.offset_bottom = 11.0

	status_row.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	add_child(
		status_row
	)

	incoming_status_label = Label.new()

	incoming_status_label.name = (
		"IncomingTrafficLabel"
	)

	incoming_status_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	incoming_status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_LEFT
	)

	incoming_status_label.add_theme_font_size_override(
		"font_size",
		STATUS_FONT_SIZE
	)

	incoming_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.CHART_LINE_BLUE
	)

	incoming_status_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	status_row.add_child(
		incoming_status_label
	)

	outgoing_status_label = Label.new()

	outgoing_status_label.name = (
		"OutgoingTrafficLabel"
	)

	outgoing_status_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	outgoing_status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	outgoing_status_label.add_theme_font_size_override(
		"font_size",
		STATUS_FONT_SIZE
	)

	outgoing_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.CHART_LINE_GREEN
	)

	outgoing_status_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	status_row.add_child(
		outgoing_status_label
	)


func build_time_display() -> void:
	time_row = HBoxContainer.new()

	time_row.name = "TrafficTimeRow"

	time_row.set_anchors_preset(
		Control.PRESET_BOTTOM_WIDE
	)

	time_row.offset_left = 4.0
	time_row.offset_top = -10.0
	time_row.offset_right = -4.0
	time_row.offset_bottom = 0.0

	time_row.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	add_child(
		time_row
	)

	oldest_time_label = create_time_label(
		"-24h",
		HORIZONTAL_ALIGNMENT_LEFT
	)

	middle_time_label = create_time_label(
		"-12h",
		HORIZONTAL_ALIGNMENT_CENTER
	)

	newest_time_label = create_time_label(
		"NOW",
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	time_row.add_child(
		oldest_time_label
	)

	time_row.add_child(
		middle_time_label
	)

	time_row.add_child(
		newest_time_label
	)


func create_time_label(
	label_text: String,
	alignment: HorizontalAlignment
) -> Label:
	var time_label: Label = Label.new()

	time_label.text = label_text

	time_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	time_label.horizontal_alignment = alignment

	time_label.add_theme_font_size_override(
		"font_size",
		TIME_FONT_SIZE
	)

	time_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	time_label.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	return time_label


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

	refresh_chart_labels()

	queue_redraw()


# -------------------------------------------------------------------
# Live Labels
# -------------------------------------------------------------------

func refresh_chart_labels() -> void:
	if incoming_status_label == null:
		return

	if outgoing_status_label == null:
		return

	var current_incoming: float = 0.0
	var current_outgoing: float = 0.0

	if not incoming_traffic.is_empty():
		current_incoming = (
			incoming_traffic[
				incoming_traffic.size() - 1
			]
		)

	if not outgoing_traffic.is_empty():
		current_outgoing = (
			outgoing_traffic[
				outgoing_traffic.size() - 1
			]
		)

	incoming_status_label.text = (
		"IN  %s"
		% format_traffic_value(
			current_incoming
		)
	)

	outgoing_status_label.text = (
		"OUT  %s"
		% format_traffic_value(
			current_outgoing
		)
	)


func format_traffic_value(
	value: float
) -> String:
	var safe_value: float = maxf(
		value,
		0.0
	)

	if safe_value >= 1000000.0:
		return "%.1fM" % (
			safe_value
			/ 1000000.0
		)

	if safe_value >= 1000.0:
		return "%.1fK" % (
			safe_value
			/ 1000.0
		)

	return str(
		roundi(
			safe_value
		)
	)


# -------------------------------------------------------------------
# Drawing
# -------------------------------------------------------------------

func _draw() -> void:
	var chart_rect: Rect2 = (
		get_chart_rect()
	)

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
