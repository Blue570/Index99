extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal revenue_changed(new_value: float)
signal active_users_changed(new_value: int)
signal indexed_pages_changed(new_value: int)
signal reputation_changed(new_value: float)
signal server_load_changed(new_value: float)

signal crawler_state_changed(is_running: bool)
signal crawler_rate_changed(new_value: float)


# -------------------------------------------------------------------
# Starting values
# -------------------------------------------------------------------

const STARTING_REVENUE: float = 0.0
const STARTING_ACTIVE_USERS: int = 10
const STARTING_INDEXED_PAGES: int = 0
const STARTING_REPUTATION: float = 1.0
const STARTING_SERVER_LOAD: float = 0.0

const STARTING_CRAWLER_RUNNING: bool = false
const STARTING_CRAWLER_RATE: float = 1.0


# -------------------------------------------------------------------
# Current values
# -------------------------------------------------------------------

var revenue: float = STARTING_REVENUE
var active_users: int = STARTING_ACTIVE_USERS
var indexed_pages: int = STARTING_INDEXED_PAGES
var reputation: float = STARTING_REPUTATION
var server_load: float = STARTING_SERVER_LOAD

var crawler_running: bool = STARTING_CRAWLER_RUNNING
var crawler_rate: float = STARTING_CRAWLER_RATE


# -------------------------------------------------------------------
# Resource setters
# -------------------------------------------------------------------

func set_revenue(new_value: float) -> void:
	var safe_value: float = maxf(new_value, 0.0)

	if is_equal_approx(revenue, safe_value):
		return

	revenue = safe_value
	revenue_changed.emit(revenue)


func set_active_users(new_value: int) -> void:
	var safe_value: int = maxi(new_value, 0)

	if active_users == safe_value:
		return

	active_users = safe_value
	active_users_changed.emit(active_users)


func set_indexed_pages(new_value: int) -> void:
	var safe_value: int = maxi(new_value, 0)

	if indexed_pages == safe_value:
		return

	indexed_pages = safe_value
	indexed_pages_changed.emit(indexed_pages)


func set_reputation(new_value: float) -> void:
	var safe_value: float = maxf(new_value, 0.0)

	if is_equal_approx(reputation, safe_value):
		return

	reputation = safe_value
	reputation_changed.emit(reputation)


func set_server_load(new_value: float) -> void:
	var safe_value: float = clampf(
		new_value,
		0.0,
		100.0
	)

	if is_equal_approx(server_load, safe_value):
		return

	server_load = safe_value
	server_load_changed.emit(server_load)


# -------------------------------------------------------------------
# Crawler setters
# -------------------------------------------------------------------

func set_crawler_running(is_running: bool) -> void:
	if crawler_running == is_running:
		return

	crawler_running = is_running
	crawler_state_changed.emit(crawler_running)


func set_crawler_rate(new_value: float) -> void:
	var safe_value: float = maxf(new_value, 0.0)

	if is_equal_approx(crawler_rate, safe_value):
		return

	crawler_rate = safe_value
	crawler_rate_changed.emit(crawler_rate)


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_state() -> void:
	set_revenue(STARTING_REVENUE)
	set_active_users(STARTING_ACTIVE_USERS)
	set_indexed_pages(STARTING_INDEXED_PAGES)
	set_reputation(STARTING_REPUTATION)
	set_server_load(STARTING_SERVER_LOAD)

	set_crawler_running(STARTING_CRAWLER_RUNNING)
	set_crawler_rate(STARTING_CRAWLER_RATE)
