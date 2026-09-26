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

const AUTO_ASSIST_INCOMING_TRAFFIC_PER_WORK: float = 4.0
const AUTO_ASSIST_OUTGOING_TRAFFIC_PER_WORK: float = 3.0

const SERVER_RESPONSE_DEGRADATION_START: float = 70.0
const SERVER_RESPONSE_WARNING_POINT: float = 90.0

const SERVER_RESPONSE_WARNING_MULTIPLIER: float = 0.85
const SERVER_RESPONSE_CRITICAL_MULTIPLIER: float = 0.60

const BASIC_CRAWL_TRAFFIC_MULTIPLIER: float = 1.00
const EXPANDED_CRAWL_TRAFFIC_MULTIPLIER: float = 1.25
const DEEP_CRAWL_TRAFFIC_MULTIPLIER: float = 1.55

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
	
func get_crawl_job_traffic_multiplier() -> float:
	var selected_job_id: StringName = (
		CrawlerManager.get_selected_job_id()
	)

	match selected_job_id:
		CrawlerManager.CRAWL_JOB_EXPANDED:
			return (
				EXPANDED_CRAWL_TRAFFIC_MULTIPLIER
			)

		CrawlerManager.CRAWL_JOB_DEEP:
			return (
				DEEP_CRAWL_TRAFFIC_MULTIPLIER
			)

		_:
			return (
				BASIC_CRAWL_TRAFFIC_MULTIPLIER
			)
			
func get_server_response_multiplier() -> float:
	var server_usage_percent: float = (
		CrawlerManager.get_server_load_usage_percent(
			GameState.server_load
		)
	)

	if (
		server_usage_percent
		<= SERVER_RESPONSE_DEGRADATION_START
	):
		return 1.0

	if (
		server_usage_percent
		<= SERVER_RESPONSE_WARNING_POINT
	):
		var warning_range: float = (
			SERVER_RESPONSE_WARNING_POINT
			- SERVER_RESPONSE_DEGRADATION_START
		)

		var warning_progress: float = (
			server_usage_percent
			- SERVER_RESPONSE_DEGRADATION_START
		) / warning_range

		return lerpf(
			1.0,
			SERVER_RESPONSE_WARNING_MULTIPLIER,
			clampf(
				warning_progress,
				0.0,
				1.0
			)
		)

	var critical_range: float = (
		100.0
		- SERVER_RESPONSE_WARNING_POINT
	)

	var critical_progress: float = (
		server_usage_percent
		- SERVER_RESPONSE_WARNING_POINT
	) / critical_range

	return lerpf(
		SERVER_RESPONSE_WARNING_MULTIPLIER,
		SERVER_RESPONSE_CRITICAL_MULTIPLIER,
		clampf(
			critical_progress,
			0.0,
			1.0
		)
	)


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
		var crawl_job_multiplier: float = (
			get_crawl_job_traffic_multiplier()
		)

		var effective_crawler_rate: float = (
			CrawlerManager
			.get_effective_automatic_crawl_rate()
		)

		var crawler_incoming_traffic: float = (
			effective_crawler_rate
			* CRAWLER_INCOMING_TRAFFIC_PER_RATE
			* crawl_job_multiplier
		)

		var crawler_outgoing_traffic: float = (
			effective_crawler_rate
			* CRAWLER_OUTGOING_TRAFFIC_PER_RATE
			* crawl_job_multiplier
		)

		incoming_base += (
			crawler_incoming_traffic
		)

		outgoing_base += (
			crawler_outgoing_traffic
		)

		if AutomationManager.is_auto_assist_active():
			var auto_assist_work_rate: float = (
				AutomationManager
				.get_auto_assist_work_per_second()
			)

			var automation_incoming_traffic: float = (
				auto_assist_work_rate
				* AUTO_ASSIST_INCOMING_TRAFFIC_PER_WORK
				* crawl_job_multiplier
			)

			var automation_outgoing_traffic: float = (
				auto_assist_work_rate
				* AUTO_ASSIST_OUTGOING_TRAFFIC_PER_WORK
				* crawl_job_multiplier
			)

			incoming_base += (
				automation_incoming_traffic
			)

			outgoing_base += (
				automation_outgoing_traffic
			)

	var server_response_multiplier: float = (
		get_server_response_multiplier()
	)

	outgoing_base *= (
		server_response_multiplier
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
	
# -------------------------------------------------------------------
# Save / Load Support
# -------------------------------------------------------------------

func get_save_data() -> Dictionary:
	return {
		"incoming_history":
			incoming_traffic_history.duplicate(),

		"outgoing_history":
			outgoing_traffic_history.duplicate(),

		"current_simulated_hour":
			current_simulated_hour
	}


func restore_saved_state(
	data: Dictionary
) -> void:
	if data.is_empty():
		reset_traffic_history()
		return

	var restored_incoming: Array[float] = (
		read_traffic_history(
			data,
			"incoming_history"
		)
	)

	var restored_outgoing: Array[float] = (
		read_traffic_history(
			data,
			"outgoing_history"
		)
	)

	if (
		restored_incoming.size()
		!= HISTORY_LENGTH
		or restored_outgoing.size()
		!= HISTORY_LENGTH
	):
		push_warning(
			"TrafficManager: Invalid saved traffic history. "
			+ "Generating fresh traffic data."
		)

		reset_traffic_history()
		return

	incoming_traffic_history = (
		restored_incoming
	)

	outgoing_traffic_history = (
		restored_outgoing
	)

	var restored_hour: int = (
		current_simulated_hour
	)

	if data.has(
		"current_simulated_hour"
	):
		var raw_hour: Variant = data[
			"current_simulated_hour"
		]

		if (
			typeof(raw_hour) == TYPE_INT
			or typeof(raw_hour) == TYPE_FLOAT
		):
			restored_hour = maxi(
				int(raw_hour),
				0
			)

	current_simulated_hour = (
		restored_hour
	)

	restart_simulation_timer()

	traffic_history_changed.emit()


func read_traffic_history(
	data: Dictionary,
	key: String
) -> Array[float]:
	var result: Array[float] = []

	if not data.has(key):
		return result

	var raw_history: Variant = (
		data[key]
	)

	if typeof(raw_history) != TYPE_ARRAY:
		return result

	for raw_value: Variant in raw_history:
		if (
			typeof(raw_value) != TYPE_FLOAT
			and typeof(raw_value) != TYPE_INT
		):
			return []

		result.append(
			maxf(
				float(raw_value),
				MINIMUM_TRAFFIC
			)
		)

	return result


# -------------------------------------------------------------------
# Reset Support
# -------------------------------------------------------------------

func reset_traffic_history() -> void:
	initialize_traffic_history()

	restart_simulation_timer()

	traffic_history_changed.emit()


func restart_simulation_timer() -> void:
	if traffic_timer == null:
		return

	traffic_timer.stop()
	traffic_timer.start()
