extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal traffic_history_changed


# -------------------------------------------------------------------
# Simulation Settings
# -------------------------------------------------------------------

const HISTORY_LENGTH: int = 24

# Temporary development speed:
# 10 real seconds = 1 simulated hour.
const SIMULATED_HOUR_SECONDS: float = 10.0

const MINIMUM_TRAFFIC: float = 1.0

const CRAWLER_INCOMING_TRAFFIC_PER_RATE: float = 6.0
const CRAWLER_OUTGOING_TRAFFIC_PER_RATE: float = 4.0


# -------------------------------------------------------------------
# Traffic History
# -------------------------------------------------------------------

var incoming_traffic_history: Array[float] = []
var outgoing_traffic_history: Array[float] = []

var current_simulated_hour: int = 0


# -------------------------------------------------------------------
# Runtime
# -------------------------------------------------------------------

var traffic_timer: Timer

var random_number_generator: RandomNumberGenerator = (
	RandomNumberGenerator.new()
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	random_number_generator.randomize()

	initialize_traffic_history()
	create_traffic_timer()

	print(
		"TrafficManager loaded successfully."
	)


func create_traffic_timer() -> void:
	traffic_timer = Timer.new()

	traffic_timer.name = "TrafficSimulationTimer"

	traffic_timer.wait_time = (
		SIMULATED_HOUR_SECONDS
	)

	traffic_timer.one_shot = false
	traffic_timer.autostart = true

	add_child(
		traffic_timer
	)

	traffic_timer.timeout.connect(
		_on_traffic_timer_timeout
	)


# -------------------------------------------------------------------
# Initial History
# -------------------------------------------------------------------

func initialize_traffic_history() -> void:
	incoming_traffic_history.clear()
	outgoing_traffic_history.clear()

	for hour_index: int in range(
		HISTORY_LENGTH
	):
		var traffic_sample: Dictionary = (
			generate_traffic_sample(
				hour_index
			)
		)

		incoming_traffic_history.append(
			float(
				traffic_sample.get(
					"incoming",
					MINIMUM_TRAFFIC
				)
			)
		)

		outgoing_traffic_history.append(
			float(
				traffic_sample.get(
					"outgoing",
					MINIMUM_TRAFFIC
				)
			)
		)

	current_simulated_hour = (
		HISTORY_LENGTH - 1
	)


# -------------------------------------------------------------------
# Simulation
# -------------------------------------------------------------------

func _on_traffic_timer_timeout() -> void:
	advance_simulated_hour()


func advance_simulated_hour() -> void:
	current_simulated_hour += 1

	var traffic_sample: Dictionary = (
		generate_traffic_sample(
			current_simulated_hour
		)
	)

	incoming_traffic_history.append(
		float(
			traffic_sample.get(
				"incoming",
				MINIMUM_TRAFFIC
			)
		)
	)

	outgoing_traffic_history.append(
		float(
			traffic_sample.get(
				"outgoing",
				MINIMUM_TRAFFIC
			)
		)
	)

	while (
		incoming_traffic_history.size()
		> HISTORY_LENGTH
	):
		incoming_traffic_history.pop_front()

	while (
		outgoing_traffic_history.size()
		> HISTORY_LENGTH
	):
		outgoing_traffic_history.pop_front()

	traffic_history_changed.emit()


func generate_traffic_sample(
	hour_index: int
) -> Dictionary:
	var active_users: float = maxf(
		float(
			GameState.active_users
		),
		1.0
	)

	var hour_of_day: int = (
		hour_index % 24
	)

	var hour_angle: float = (
		float(hour_of_day)
		/ 24.0
		* TAU
	)

	var daily_activity_multiplier: float = (
		1.0
		+ sin(
			hour_angle
			- PI / 2.0
		)
		* 0.25
	)

	var incoming_base: float = (
		active_users
		* daily_activity_multiplier
	)

	var outgoing_base: float = (
		active_users
		* daily_activity_multiplier
		* 0.78
	)

	if GameState.crawler_running:
		incoming_base += (
			GameState.crawler_rate
			* CRAWLER_INCOMING_TRAFFIC_PER_RATE
		)

		outgoing_base += (
			GameState.crawler_rate
			* CRAWLER_OUTGOING_TRAFFIC_PER_RATE
		)

	var incoming_variation: float = (
		random_number_generator.randf_range(
			0.90,
			1.10
		)
	)

	var outgoing_variation: float = (
		random_number_generator.randf_range(
			0.90,
			1.10
		)
	)

	var incoming_value: float = maxf(
		incoming_base
		* incoming_variation,
		MINIMUM_TRAFFIC
	)

	var outgoing_value: float = maxf(
		outgoing_base
		* outgoing_variation,
		MINIMUM_TRAFFIC
	)

	return {
		"incoming": incoming_value,
		"outgoing": outgoing_value
	}
