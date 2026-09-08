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

func string_name_array_to_strings(
	values: Array[StringName]
) -> Array[String]:
	var result: Array[String] = []

	for value: StringName in values:
		result.append(
			str(value)
		)

	return result

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
				CrawlerManager.paused_for_overload,
				
			"selected_job_id":
				str(
				CrawlerManager.get_selected_job_id()
			),
			
			"priority_id":
				str(
					CrawlerManager.get_current_crawler_priority()
				),

			"quick_crawl_job_ids":
				string_name_array_to_strings(
					CrawlerManager.get_quick_crawl_job_ids()
				),

			"crawl_job_queue":
				string_name_array_to_strings(
					CrawlerManager.get_crawl_job_queue()
				)
		},
		
			"automation": {
				"auto_restart_unlocked":
					AutomationManager.is_auto_restart_unlocked(),

				"auto_restart_enabled":
					AutomationManager.is_auto_restart_enabled(),

				"scheduler_enabled":
					AutomationManager.is_scheduler_enabled()
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
		},
		
		"tutorial":{
			"current_step_index":
				TutorialManager.current_step_index,
				
			"completed":
				TutorialManager.tutorial_has_been_completed
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
	
func copy_string_name_array(
	values: Array[StringName]
) -> Array[StringName]:
	var result: Array[StringName] = []

	for value: StringName in values:
		result.append(
			value
		)

	return result


func read_string_name_array(
	data: Dictionary,
	key: String,
	fallback: Array[StringName]
) -> Array[StringName]:
	if not data.has(
		key
	):
		return copy_string_name_array(
			fallback
		)

	var value: Variant = data[
		key
	]

	if typeof(value) != TYPE_ARRAY:
		push_warning(
			"SaveManager: Invalid array '%s'."
			% key
		)

		return copy_string_name_array(
			fallback
		)

	var raw_values: Array = value

	var result: Array[StringName] = []

	for raw_value: Variant in raw_values:
		if (
			typeof(raw_value) != TYPE_STRING
			and typeof(raw_value)
			!= TYPE_STRING_NAME
		):
			push_warning(
				"SaveManager: Invalid value "
				+ "inside array '%s'."
				% key
			)

			continue

		result.append(
			StringName(
				str(raw_value)
			)
		)

	return result
	
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
		
		TutorialManager.reset_tutorial()
		
		call_deferred(
			"start_tutorial_after_load"
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
	
	call_deferred(
		"start_tutorial_after_load"
	)

	return true
	
func start_tutorial_after_load() -> void:
	if not TutorialManager.should_start_tutorial():
		return

	TutorialManager.start_tutorial()
	
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
	
	var automation_data: Dictionary = {}

	if (
		save_data.has("automation")
		and typeof(save_data["automation"])
		== TYPE_DICTIONARY
	):
		automation_data = save_data["automation"]

	var tutorial_data: Dictionary = {}

	if (
		save_data.has("tutorial")
		and typeof(save_data["tutorial"])
		== TYPE_DICTIONARY
	):
		tutorial_data = save_data["tutorial"]

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
	
	restore_crawl_job_configuration(
		crawler_data
	)
	
	restore_crawler_priority(
		crawler_data
	)
	
	restore_automation(
		automation_data
	)

	restore_tutorial(
		tutorial_data
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
	var saved_job_pages: int = read_int(
		data,
		"current_job_pages",
		0
	)

	var saved_page_fraction: float = read_float(
		data,
		"page_fraction_buffer",
		0.0
	)

	var saved_active_user_fraction: float = read_float(
		data,
		"active_user_fraction_buffer",
		0.0
	)

	var saved_running: bool = read_bool(
		data,
		"running",
		false
	)

	var saved_paused_for_overload: bool = read_bool(
		data,
		"paused_for_overload",
		false
	)

	var saved_job_id: StringName = StringName(
		str(
			data.get(
				"selected_job_id",
				"basic"
			)
		)
	)
	
	print(
	"LOADING CRAWL JOB: ",
	saved_job_id
	)

	CrawlerManager.restore_saved_state(
		saved_job_pages,
		saved_page_fraction,
		saved_active_user_fraction,
		saved_running,
		saved_paused_for_overload,
		saved_job_id
	)
	
	
# -------------------------------------------------------------------
# Restore Crawl Job Configuration
# -------------------------------------------------------------------

func restore_crawl_job_configuration(
	data: Dictionary
) -> void:
	var default_quick_job_ids: Array[StringName] = [
		CrawlerManager.CRAWL_JOB_BASIC,
		CrawlerManager.CRAWL_JOB_EXPANDED,
		CrawlerManager.CRAWL_JOB_DEEP
	]

	var default_queue: Array[StringName] = []

	var saved_quick_job_ids: Array[StringName] = (
		read_string_name_array(
			data,
			"quick_crawl_job_ids",
			default_quick_job_ids
		)
	)

	var saved_queue: Array[StringName] = (
		read_string_name_array(
			data,
			"crawl_job_queue",
			default_queue
		)
	)

	CrawlerManager.restore_crawl_job_configuration(
		saved_quick_job_ids,
		saved_queue
	)
	
# -------------------------------------------------------------------
# Restore Crawler Priority
# -------------------------------------------------------------------

func restore_crawler_priority(
	data: Dictionary
) -> void:
	var saved_priority: StringName = StringName(
		str(
			data.get(
				"priority_id",
				"balanced"
			)
		)
	)

	# Protect against an invalid or outdated value.
	if not CrawlerManager.is_crawler_priority_valid(
		saved_priority
	):
		push_warning(
			"SaveManager: Invalid crawler priority '%s'. "
			+ "Falling back to Balanced."
			% str(saved_priority)
		)

		saved_priority = (
			CrawlerManager.PRIORITY_BALANCED
		)

	# Speed and Efficiency are Tier 2 mechanics.
	# A Tier 1 save must always use Balanced.
	if not CrawlerManager.is_crawler_priority_unlocked():
		saved_priority = (
			CrawlerManager.PRIORITY_BALANCED
		)

	CrawlerManager.set_crawler_priority(
		saved_priority
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
	
func restore_tutorial(
	data: Dictionary
) -> void:
	var saved_step_index: int = 0
	var saved_completed: bool = false

	if not data.is_empty():
		saved_step_index = read_int(
			data,
			"current_step_index",
			0
		)

		saved_completed = read_bool(
			data,
			"completed",
			false
		)

	TutorialManager.restore_saved_state(
		saved_step_index,
		saved_completed
	)
	
	
# -------------------------------------------------------------------
# Restore Automation
# -------------------------------------------------------------------

func restore_automation(
	data: Dictionary
) -> void:
	var saved_auto_restart_unlocked: bool = false

	if data.has(
		"auto_restart_unlocked"
	):
		saved_auto_restart_unlocked = read_bool(
			data,
			"auto_restart_unlocked",
			false
		)

	var saved_auto_restart_enabled: bool = (
		saved_auto_restart_unlocked
	)

	if data.has(
		"auto_restart_enabled"
	):
		saved_auto_restart_enabled = read_bool(
			data,
			"auto_restart_enabled",
			saved_auto_restart_unlocked
		)

	var saved_scheduler_enabled: bool = false

	if data.has(
		"scheduler_enabled"
	):
		saved_scheduler_enabled = read_bool(
			data,
			"scheduler_enabled",
			false
		)

	AutomationManager.restore_auto_restart_state(
		saved_auto_restart_unlocked,
		saved_auto_restart_enabled
	)

	AutomationManager.restore_scheduler_state(
		saved_scheduler_enabled
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
		
	if not CrawlerManager.crawler_priority_changed.is_connected(
		_on_crawler_priority_changed_for_save
	):
		CrawlerManager.crawler_priority_changed.connect(
			_on_crawler_priority_changed_for_save
		)
		
	if not TutorialManager.tutorial_step_changed.is_connected(
		_on_tutorial_step_changed_for_save
	):
		TutorialManager.tutorial_step_changed.connect(
			_on_tutorial_step_changed_for_save
		)

	if not TutorialManager.tutorial_completed.is_connected(
		_on_tutorial_completed_for_save
	):
		TutorialManager.tutorial_completed.connect(
			_on_tutorial_completed_for_save
		)

	if not TutorialManager.tutorial_skipped.is_connected(
		_on_tutorial_skipped_for_save
	):
		TutorialManager.tutorial_skipped.connect(
			_on_tutorial_skipped_for_save
		)
		
	if not AutomationManager.auto_restart_unlock_changed.is_connected(
		_on_auto_restart_unlock_changed_for_save
	):
		AutomationManager.auto_restart_unlock_changed.connect(
			_on_auto_restart_unlock_changed_for_save
		)

	if not AutomationManager.auto_restart_enabled_changed.is_connected(
		_on_auto_restart_enabled_changed_for_save
	):
		AutomationManager.auto_restart_enabled_changed.connect(
			_on_auto_restart_enabled_changed_for_save
		)
		
	if not CrawlerManager.quick_crawl_jobs_changed.is_connected(
		_on_quick_crawl_jobs_changed_for_save
	):
		CrawlerManager.quick_crawl_jobs_changed.connect(
			_on_quick_crawl_jobs_changed_for_save
		)

	if not CrawlerManager.crawl_job_queue_changed.is_connected(
		_on_crawl_job_queue_changed_for_save
	):
		CrawlerManager.crawl_job_queue_changed.connect(
			_on_crawl_job_queue_changed_for_save
		)

	if not AutomationManager.scheduler_enabled_changed.is_connected(
		_on_scheduler_enabled_changed_for_save
	):
		AutomationManager.scheduler_enabled_changed.connect(
			_on_scheduler_enabled_changed_for_save
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
	
func _on_crawler_priority_changed_for_save(
	_new_priority: StringName
) -> void:
	request_event_autosave()
	
func _on_tutorial_step_changed_for_save(
	_step_id: StringName,
	_title: String,
	_message: String
) -> void:
	request_event_autosave()


func _on_tutorial_completed_for_save() -> void:
	request_event_autosave()


func _on_tutorial_skipped_for_save() -> void:
	request_event_autosave()
	
func _on_quick_crawl_jobs_changed_for_save() -> void:
	request_event_autosave()


func _on_crawl_job_queue_changed_for_save() -> void:
	request_event_autosave()


func _on_scheduler_enabled_changed_for_save(
	_is_enabled: bool
) -> void:
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
	
func _on_auto_restart_unlock_changed_for_save(
	_is_unlocked: bool
) -> void:
	request_event_autosave()


func _on_auto_restart_enabled_changed_for_save(
	_is_enabled: bool
) -> void:
	request_event_autosave()
	
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
	
	TutorialManager.reset_tutorial()

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
	
	call_deferred(
		"start_tutorial_after_load"
	)
	
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
