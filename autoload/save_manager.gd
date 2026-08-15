extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal save_completed(
	save_path: String
)

signal load_completed(
	save_path: String
)

signal load_failed(
	reason: String
)

signal new_game_reset


# -------------------------------------------------------------------
# Save settings
# -------------------------------------------------------------------

const SAVE_PATH: String = (
	"user://index99_save.json"
)

const SAVE_VERSION: int = 1

const AUTOSAVE_INTERVAL_SECONDS: float = 30.0


# -------------------------------------------------------------------
# Autosave
# -------------------------------------------------------------------

var autosave_timer: Timer

var event_autosave_queued: bool = false
var save_actions_blocked: bool = false

var new_game_defaults: Dictionary = {}


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	capture_new_game_defaults()

	create_autosave_timer()
	connect_event_autosave_signals()

	call_deferred(
		"load_game"
	)
	
# -------------------------------------------------------------------
# New-game defaults
# -------------------------------------------------------------------

func capture_new_game_defaults() -> void:
	new_game_defaults = {
		"revenue": GameState.revenue,
		"active_users": GameState.active_users,
		"indexed_pages": GameState.indexed_pages,
		"reputation": GameState.reputation,
		"server_load": GameState.server_load
	}


func _notification(
	what: int
) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()


func create_autosave_timer() -> void:
	autosave_timer = Timer.new()

	autosave_timer.name = (
		"AutosaveTimer"
	)

	autosave_timer.wait_time = (
		AUTOSAVE_INTERVAL_SECONDS
	)

	autosave_timer.one_shot = false
	autosave_timer.autostart = true

	add_child(
		autosave_timer
	)

	autosave_timer.timeout.connect(
		_on_autosave_timeout
	)


func _on_autosave_timeout() -> void:
	if save_actions_blocked:
		return

	save_game()
	
# -------------------------------------------------------------------
# Build save data
# -------------------------------------------------------------------

func build_save_data() -> Dictionary:
	return {
		"save_version": SAVE_VERSION,

		"game_state": {
			"revenue": GameState.revenue,
			"active_users": GameState.active_users,
			"indexed_pages": GameState.indexed_pages,
			"reputation": GameState.reputation,
			"server_load": GameState.server_load
		},

		"crawler": {
			"current_job_pages":
				CrawlerManager.current_job_pages,

			"page_fraction_buffer":
				CrawlerManager.page_fraction_buffer,

			"active_user_fraction_buffer":
				CrawlerManager.active_user_fraction_buffer,

			"running":
				GameState.crawler_running,

			"paused_for_overload":
				CrawlerManager.paused_for_overload
		},

		"server_upgrades": {
			"cooling_speed_level":
				ServerManager.cooling_speed_level,

			"crawler_efficiency_level":
				ServerManager.crawler_efficiency_level,

			"maximum_safe_load_level":
				ServerManager.maximum_safe_load_level
		},

		"research": {
			"research_points":
				ResearchManager.research_points,

			"crawler_optimization_level":
				ResearchManager.get_upgrade_level(
					ResearchManager
					.UPGRADE_CRAWLER_OPTIMIZATION
				),

			"search_monetization_level":
				ResearchManager.get_upgrade_level(
					ResearchManager
					.UPGRADE_SEARCH_MONETIZATION
				),

			"audience_discovery_level":
				ResearchManager.get_upgrade_level(
					ResearchManager
					.UPGRADE_AUDIENCE_DISCOVERY
				),

			"crawler_optimization_unlocked":
				ResearchManager.is_upgrade_unlocked(
					ResearchManager
					.UPGRADE_CRAWLER_OPTIMIZATION
				),

			"search_monetization_unlocked":
				ResearchManager.is_upgrade_unlocked(
					ResearchManager
					.UPGRADE_SEARCH_MONETIZATION
				),

			"audience_discovery_unlocked":
				ResearchManager.is_upgrade_unlocked(
					ResearchManager
					.UPGRADE_AUDIENCE_DISCOVERY
				)
		},

		"objective": {
			"current_objective_index":
				ObjectiveManager.current_objective_index,

			"current_event_progress":
				ObjectiveManager.current_event_progress,

			"sequence_completed":
				ObjectiveManager.sequence_completed,
				
			"current_progression_tier":
				ObjectiveManager.current_progression_tier
		}
	}
	
# -------------------------------------------------------------------
# Save game
# -------------------------------------------------------------------

func save_game() -> bool:
	if save_actions_blocked:
		return false
		
	var save_data: Dictionary = (
		build_save_data()
	)

	var json_text: String = JSON.stringify(
		save_data,
		"\t"
	)

	var save_file: FileAccess = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if save_file == null:
		var open_error: Error = (
			FileAccess.get_open_error()
		)

		var message: String = (
			"Could not open save file for writing. "
			+ "Error code: %d"
			% open_error
		)

		push_error(
			"SaveManager: " + message
		)

		return false

	save_file.store_string(
		json_text
	)

	save_file.flush()

	save_completed.emit(
		SAVE_PATH
	)

	return true
	
# -------------------------------------------------------------------
# Safe save-data readers
# -------------------------------------------------------------------

func read_dictionary(
	data: Dictionary,
	key: String
) -> Dictionary:
	if not data.has(key):
		push_warning(
			"SaveManager: Missing section '%s'."
			% key
		)

		return {}

	var value: Variant = data[key]

	if typeof(value) != TYPE_DICTIONARY:
		push_warning(
			"SaveManager: Section '%s' is invalid."
			% key
		)

		return {}

	return value


func read_float(
	data: Dictionary,
	key: String,
	fallback: float
) -> float:
	if not data.has(key):
		push_warning(
			"SaveManager: Missing float '%s'."
			% key
		)

		return fallback

	var value: Variant = data[key]

	if (
		typeof(value) != TYPE_FLOAT
		and typeof(value) != TYPE_INT
	):
		push_warning(
			"SaveManager: Invalid float '%s'."
			% key
		)

		return fallback

	return float(value)


func read_int(
	data: Dictionary,
	key: String,
	fallback: int
) -> int:
	if not data.has(key):
		push_warning(
			"SaveManager: Missing integer '%s'."
			% key
		)

		return fallback

	var value: Variant = data[key]

	if (
		typeof(value) != TYPE_INT
		and typeof(value) != TYPE_FLOAT
	):
		push_warning(
			"SaveManager: Invalid integer '%s'."
			% key
		)

		return fallback

	return int(value)


func read_bool(
	data: Dictionary,
	key: String,
	fallback: bool
) -> bool:
	if not data.has(key):
		push_warning(
			"SaveManager: Missing boolean '%s'."
			% key
		)

		return fallback

	var value: Variant = data[key]

	if typeof(value) != TYPE_BOOL:
		push_warning(
			"SaveManager: Invalid boolean '%s'."
			% key
		)

		return fallback

	return bool(value)
	
# -------------------------------------------------------------------
# Load game
# -------------------------------------------------------------------

func load_game() -> bool:
	if not FileAccess.file_exists(
		SAVE_PATH
	):
		print(
			"SaveManager: No save file found. "
			+ "Starting a new game."
		)

		return false

	var save_file: FileAccess = FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if save_file == null:
		var open_error: Error = (
			FileAccess.get_open_error()
		)

		return fail_load(
			"Could not open save file. "
			+ "Error code: %d"
			% open_error
		)

	var json_text: String = (
		save_file.get_as_text()
	)

	if json_text.strip_edges().is_empty():
		return fail_load(
			"Save file is empty."
		)

	var json: JSON = JSON.new()

	var parse_result: Error = json.parse(
		json_text
	)

	if parse_result != OK:
		return fail_load(
			"Invalid JSON on line %d: %s"
			% [
				json.get_error_line(),
				json.get_error_message()
			]
		)

	var parsed_data: Variant = json.data

	if typeof(parsed_data) != TYPE_DICTIONARY:
		return fail_load(
			"Top-level save data is not a Dictionary."
		)

	var save_data: Dictionary = (
		parsed_data
	)

	if not save_data.has(
		"save_version"
	):
		return fail_load(
			"Save version is missing."
		)

	var save_version: int = read_int(
		save_data,
		"save_version",
		-1
	)

	if save_version != SAVE_VERSION:
		return fail_load(
			"Unsupported save version: %d"
			% save_version
		)

	restore_save_data(
		save_data
	)

	load_completed.emit(
		SAVE_PATH
	)

	print(
		"SaveManager: Save loaded successfully."
	)

	return true
	
func fail_load(
	reason: String
) -> bool:
	push_warning(
		"SaveManager: " + reason
	)

	load_failed.emit(
		reason
	)

	return false
	
# -------------------------------------------------------------------
# Restore saved data
# -------------------------------------------------------------------

func restore_save_data(
	save_data: Dictionary
) -> void:
	ResearchManager.begin_save_restore()
	ObjectiveManager.begin_save_restore()

	var game_data: Dictionary = read_dictionary(
		save_data,
		"game_state"
	)

	var crawler_data: Dictionary = read_dictionary(
		save_data,
		"crawler"
	)

	var server_data: Dictionary = read_dictionary(
		save_data,
		"server_upgrades"
	)

	var research_data: Dictionary = read_dictionary(
		save_data,
		"research"
	)

	var objective_data: Dictionary = read_dictionary(
		save_data,
		"objective"
	)

	restore_server_upgrades(
		server_data
	)

	restore_research(
		research_data
	)

	restore_game_state(
		game_data
	)

	restore_crawler(
		crawler_data
	)

	ResearchManager.finish_save_restore()

	restore_objective(
		objective_data
	)
	
func restore_server_upgrades(
	data: Dictionary
) -> void:
	ServerManager.set_cooling_speed_level(
		read_int(
			data,
			"cooling_speed_level",
			ServerManager.cooling_speed_level
		)
	)

	ServerManager.set_crawler_efficiency_level(
		read_int(
			data,
			"crawler_efficiency_level",
			ServerManager.crawler_efficiency_level
		)
	)

	ServerManager.set_maximum_safe_load_level(
		read_int(
			data,
			"maximum_safe_load_level",
			ServerManager.maximum_safe_load_level
		)
	)
	
func restore_research(
	data: Dictionary
) -> void:
	ResearchManager.set_research_points(
		read_float(
			data,
			"research_points",
			ResearchManager.research_points
		)
	)

	ResearchManager.set_upgrade_level(
		ResearchManager
		.UPGRADE_CRAWLER_OPTIMIZATION,
		read_int(
			data,
			"crawler_optimization_level",
			ResearchManager.get_upgrade_level(
				ResearchManager
				.UPGRADE_CRAWLER_OPTIMIZATION
			)
		)
	)

	ResearchManager.set_upgrade_level(
		ResearchManager
		.UPGRADE_SEARCH_MONETIZATION,
		read_int(
			data,
			"search_monetization_level",
			ResearchManager.get_upgrade_level(
				ResearchManager
				.UPGRADE_SEARCH_MONETIZATION
			)
		)
	)

	ResearchManager.set_upgrade_level(
		ResearchManager
		.UPGRADE_AUDIENCE_DISCOVERY,
		read_int(
			data,
			"audience_discovery_level",
			ResearchManager.get_upgrade_level(
				ResearchManager
				.UPGRADE_AUDIENCE_DISCOVERY
			)
		)
	)

	ResearchManager.unlocked_upgrades[
		ResearchManager
		.UPGRADE_CRAWLER_OPTIMIZATION
	] = read_bool(
		data,
		"crawler_optimization_unlocked",
		true
	)

	ResearchManager.unlocked_upgrades[
		ResearchManager
		.UPGRADE_SEARCH_MONETIZATION
	] = read_bool(
		data,
		"search_monetization_unlocked",
		true
	)

	ResearchManager.unlocked_upgrades[
		ResearchManager
		.UPGRADE_AUDIENCE_DISCOVERY
	] = read_bool(
		data,
		"audience_discovery_unlocked",
		true
	)
	
func restore_game_state(
	data: Dictionary
) -> void:
	GameState.set_revenue(
		read_float(
			data,
			"revenue",
			GameState.revenue
		)
	)

	GameState.set_active_users(
		read_int(
			data,
			"active_users",
			GameState.active_users
		)
	)

	GameState.set_indexed_pages(
		read_int(
			data,
			"indexed_pages",
			GameState.indexed_pages
		)
	)

	GameState.set_reputation(
		read_float(
			data,
			"reputation",
			GameState.reputation
		)
	)

	GameState.set_server_load(
		read_float(
			data,
			"server_load",
			GameState.server_load
		)
	)
	
func restore_crawler(
	data: Dictionary
) -> void:
	CrawlerManager.restore_saved_state(
		read_int(
			data,
			"current_job_pages",
			CrawlerManager.current_job_pages
		),

		read_float(
			data,
			"page_fraction_buffer",
			CrawlerManager.page_fraction_buffer
		),

		read_float(
			data,
			"active_user_fraction_buffer",
			CrawlerManager.active_user_fraction_buffer
		),

		read_bool(
			data,
			"running",
			GameState.crawler_running
		),

		read_bool(
			data,
			"paused_for_overload",
			CrawlerManager.paused_for_overload
		)
	)
	
func restore_objective(
	data: Dictionary
) -> void:
	var saved_index: int = read_int(
		data,
		"current_objective_index",
		ObjectiveManager.current_objective_index
	)

	if (
		saved_index < 0
		or saved_index
		> ObjectiveManager.OBJECTIVES.size()
	):
		push_warning(
			"SaveManager: Invalid objective index. "
			+ "Returning to Objective 1."
		)

		saved_index = 0

	var saved_event_progress: int = read_int(
		data,
		"current_event_progress",
		0
	)

	var saved_sequence_completed: bool = read_bool(
		data,
		"sequence_completed",
		false
	)

	var default_progression_tier: int = (
		ObjectiveManager.PROGRESSION_TIER_2
		if saved_sequence_completed
		else ObjectiveManager.PROGRESSION_TIER_1
	)

	var saved_progression_tier: int = read_int(
		data,
		"current_progression_tier",
		default_progression_tier
	)

	ObjectiveManager.restore_saved_state(
		saved_index,
		saved_event_progress,
		saved_sequence_completed,
		saved_progression_tier
	)
	
# -------------------------------------------------------------------
# Event autosave connections
# -------------------------------------------------------------------

func connect_event_autosave_signals() -> void:
	if not ServerManager.server_upgrade_purchased.is_connected(
		_on_server_upgrade_purchased_for_save
	):
		ServerManager.server_upgrade_purchased.connect(
			_on_server_upgrade_purchased_for_save
		)

	if not ResearchManager.research_upgrade_purchased.is_connected(
		_on_research_upgrade_purchased_for_save
	):
		ResearchManager.research_upgrade_purchased.connect(
			_on_research_upgrade_purchased_for_save
		)

	if not ObjectiveManager.objective_completed.is_connected(
		_on_objective_completed_for_save
	):
		ObjectiveManager.objective_completed.connect(
			_on_objective_completed_for_save
		)

	if not CrawlerManager.crawl_job_completed.is_connected(
		_on_crawl_job_completed_for_save
	):
		CrawlerManager.crawl_job_completed.connect(
			_on_crawl_job_completed_for_save
		)
		
func _on_server_upgrade_purchased_for_save(
	_upgrade_id: StringName,
	_new_level: int,
	_revenue_spent: float
) -> void:
	request_event_autosave()


func _on_research_upgrade_purchased_for_save(
	_upgrade_id: StringName,
	_new_level: int,
	_research_points_spent: float
) -> void:
	request_event_autosave()


func _on_objective_completed_for_save(
	_objective_id: StringName,
	_title: String
) -> void:
	request_event_autosave()


func _on_crawl_job_completed_for_save() -> void:
	request_event_autosave()
	
func request_event_autosave() -> void:
	if save_actions_blocked:
		return

	if event_autosave_queued:
		return

	event_autosave_queued = true

	call_deferred(
		"perform_event_autosave"
	)


func perform_event_autosave() -> void:
	event_autosave_queued = false

	if save_actions_blocked:
		return

	save_game()
	
# -------------------------------------------------------------------
# Controlled new-game reset
# -------------------------------------------------------------------

func reset_to_new_game() -> bool:
	if new_game_defaults.is_empty():
		push_error(
			"SaveManager: New-game defaults are unavailable."
		)

		return false

	save_actions_blocked = true
	event_autosave_queued = false

	ResearchManager.begin_save_restore()
	ObjectiveManager.begin_save_restore()

	CrawlerManager.reset_crawler_state()

	ServerManager.reset_upgrade_levels()

	GameState.set_revenue(
		float(
			new_game_defaults["revenue"]
		)
	)

	GameState.set_active_users(
		int(
			new_game_defaults["active_users"]
		)
	)

	GameState.set_indexed_pages(
		int(
			new_game_defaults["indexed_pages"]
		)
	)

	GameState.set_reputation(
		float(
			new_game_defaults["reputation"]
		)
	)

	GameState.set_server_load(
		float(
			new_game_defaults["server_load"]
		)
	)

	ResearchManager.reset_research()

	ResearchManager.finish_save_restore()

	ObjectiveManager.restore_saved_state(
		0,
		0,
		false,
		ObjectiveManager.PROGRESSION_TIER_1
	)

	CrawlerManager.apply_research_crawler_rate()

	save_actions_blocked = false

	var save_successful: bool = (
		save_game()
	)

	if save_successful:
		print(
			"SaveManager: New game reset completed."
		)

	else:
		push_warning(
			"SaveManager: Runtime reset completed, "
			+ "but the new save could not be written."
		)
	
	new_game_reset.emit()
	return save_successful
	
# -------------------------------------------------------------------
# Debug reset shortcut
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
		key_event.keycode == KEY_F12
		and key_event.ctrl_pressed
		and key_event.shift_pressed
	):
		reset_to_new_game()
