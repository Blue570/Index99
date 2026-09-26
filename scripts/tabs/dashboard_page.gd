extends PanelContainer


const OBJECTIVE_TARGET: int = 100


# -------------------------------------------------------------------
# Traffic Overview
# -------------------------------------------------------------------

@onready var revenue_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "RevenueMetricPanel/RevenueMetricLayout/"
	+ "RevenueValueLabel"
) as Label

@onready var active_users_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "ActiveUsersMetricPanel/ActiveUsersMetricLayout/"
	+ "ActiveUsersValueLabel"
) as Label

@onready var indexed_pages_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/TrafficOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "TrafficOverviewLayout/TrafficMetricsRow/"
	+ "IndexedPagesMetricPanel/IndexedPagesMetricLayout/"
	+ "IndexedPagesValueLabel"
) as Label


# -------------------------------------------------------------------
# Crawler Overview
# -------------------------------------------------------------------

@onready var crawler_overview: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview"
) as SectionPanel

@onready var crawler_status_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerOverviewLayout/CrawlerStatusRow/"
	+ "CrawlerStatusValueLabel"
) as Label

@onready var crawler_rate_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "OverviewLeftGroup/CrawlerOverview/PanelLayout/"
	+ "ContentPanel/ContentMargin/ContentContainer/"
	+ "CrawlerOverviewLayout/CrawlerRateRow/"
	+ "CrawlerRateValueLabel"
) as Label


# -------------------------------------------------------------------
# Server Overview
# -------------------------------------------------------------------

@onready var server_overview: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview"
) as SectionPanel

@onready var server_load_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerLoadRow/"
	+ "ServerLoadValueLabel"
) as Label

@onready var server_load_progress: ProgressBar = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerLoadProgress"
) as ProgressBar

@onready var server_health_value_label: Label = get_node(
	"DashboardMargin/DashboardLayout/OverviewRow/"
	+ "ServerOverview/PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ServerOverviewLayout/ServerHealthRow/"
	+ "ServerHealthValueLabel"
) as Label


# -------------------------------------------------------------------
# Recent Events
# -------------------------------------------------------------------

@onready var recent_events_panel: SectionPanel = (
	find_child(
		"RecentEventsPanel",
		true,
		false
	) as SectionPanel
)


# Event Row 1

@onready var event_1_time_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow1Panel/"
		+ "EventRow1Layout/Event1TimeLabel"
	) as Label
)

@onready var event_1_type_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow1Panel/"
		+ "EventRow1Layout/Event1TypeLabel"
	) as Label
)

@onready var event_1_message_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow1Panel/"
		+ "EventRow1Layout/Event1MessageLabel"
	) as Label
)


# Event Row 2

@onready var event_2_time_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow2Panel/"
		+ "EventRow2Layout/Event2TimeLabel"
	) as Label
)

@onready var event_2_type_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow2Panel/"
		+ "EventRow2Layout/Event2TypeLabel"
	) as Label
)

@onready var event_2_message_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow2Panel/"
		+ "EventRow2Layout/Event2MessageLabel"
	) as Label
)


# Event Row 3

@onready var event_3_time_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow3Panel/"
		+ "EventRow3Layout/Event3TimeLabel"
	) as Label
)

@onready var event_3_type_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow3Panel/"
		+ "EventRow3Layout/Event3TypeLabel"
	) as Label
)

@onready var event_3_message_label: Label = (
	recent_events_panel.get_node(
		"PanelLayout/ContentPanel/"
		+ "ContentMargin/ContentContainer/"
		+ "RecentEventsLayout/EventRow3Panel/"
		+ "EventRow3Layout/Event3MessageLabel"
	) as Label
)


# -------------------------------------------------------------------
# Current Objective
# -------------------------------------------------------------------

@onready var current_objective_panel: SectionPanel = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel"
) as SectionPanel

@onready var objective_title_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "ObjectiveTitleLabel"
) as Label

@onready var objective_description_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "ObjectiveDescriptionLabel"
) as Label

@onready var objective_progress_bar: ProgressBar = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "ObjectiveProgressBar"
) as ProgressBar

@onready var objective_progress_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "ObjectiveProgressLabel"
) as Label

@onready var objective_2_container: VBoxContainer = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "Objective2Container"
) as VBoxContainer

@onready var objective_2_title_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "Objective2Container/"
	+ "Objective2TitleLabel"
) as Label

@onready var objective_2_description_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "Objective2Container/"
	+ "Objective2DescriptionLabel"
) as Label

@onready var objective_2_progress_bar: ProgressBar = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "Objective2Container/"
	+ "Objective2ProgressBar"
) as ProgressBar

@onready var objective_2_progress_label: Label = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout/"
	+ "Objective2Container/"
	+ "Objective2ProgressLabel"
) as Label

@onready var current_objective_layout: VBoxContainer = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CurrentObjectiveLayout"
) as VBoxContainer

@onready var tier_2_objective_scroll: ScrollContainer = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "Tier2ObjectiveScroll"
) as ScrollContainer

@onready var tier_2_objective_list: VBoxContainer = get_node(
	"DashboardMargin/DashboardLayout/"
	+ "DashboardColumns/RightColumn/"
	+ "CurrentObjectivePanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "Tier2ObjectiveScroll/"
	+ "Tier2ObjectiveMargin/"
	+ "Tier2ObjectiveList"
) as VBoxContainer

var tier_2_objective_rows: Dictionary = {}

var tier_2_capstone_nodes: Dictionary = {}


func _ready() -> void:
	connect_game_state_signals()
	refresh_dashboard()

	connect_objective_signals()
	refresh_current_objective()

	connect_event_log_signals()
	refresh_recent_events()
	

# -------------------------------------------------------------------
# Recent Events setup
# -------------------------------------------------------------------

func connect_event_log_signals() -> void:
	if not EventLogManager.history_changed.is_connected(
		_on_event_history_changed
	):
		EventLogManager.history_changed.connect(
			_on_event_history_changed
		)


func _on_event_history_changed() -> void:
	refresh_recent_events()
	
func refresh_recent_events() -> void:
	var recent_events: Array[Dictionary] = (
		EventLogManager.get_recent_events(3)
	)

	var time_labels: Array[Label] = [
		event_1_time_label,
		event_2_time_label,
		event_3_time_label
	]

	var type_labels: Array[Label] = [
		event_1_type_label,
		event_2_type_label,
		event_3_type_label
	]

	var message_labels: Array[Label] = [
		event_1_message_label,
		event_2_message_label,
		event_3_message_label
	]

	for event_index: int in range(3):
		if event_index < recent_events.size():
			var event_data: Dictionary = (
				recent_events[event_index]
			)

			time_labels[event_index].text = str(
				event_data.get(
					"time",
					"--:--"
				)
			)

			type_labels[event_index].text = (
				get_event_type_text(
					event_data.get(
						"category",
						&"information"
					) as StringName
				)
			)

			message_labels[event_index].text = str(
				event_data.get(
					"message",
					""
				)
			)

			apply_event_type_color(
				type_labels[event_index],
				event_data.get(
					"category",
					&"information"
				) as StringName
			)

		else:
			time_labels[event_index].text = "--:--"
			type_labels[event_index].text = "SYSTEM"
			message_labels[event_index].text = (
				"No recent event."
			)

			type_labels[event_index].add_theme_color_override(
				"font_color",
				ThemeManager.TEXT_DISABLED
			)

	refresh_recent_events_status(
		recent_events.size()
	)
	
func get_event_type_text(
	category: StringName
) -> String:
	match category:
		&"crawler":
			return "CRAWLER"

		&"server":
			return "SERVER"

		&"research":
			return "RESEARCH"

		&"objective":
			return "OBJECTIVE"

		&"progression":
			return "PROGRESS"

		&"warning":
			return "WARNING"

		&"success":
			return "SUCCESS"

	return "SYSTEM"
	
func apply_event_type_color(
	type_label: Label,
	category: StringName
) -> void:
	var event_color: Color = (
		ThemeManager.TEXT_SECONDARY
	)

	match category:
		&"warning":
			event_color = (
				ThemeManager.STATUS_WARNING
			)

		&"success":
			event_color = (
				ThemeManager.STATUS_SUCCESS
			)

		&"objective":
			event_color = (
				ThemeManager.STATUS_SUCCESS
			)

		&"progression":
			event_color = (
				ThemeManager.STATUS_SUCCESS
			)

		&"server":
			event_color = (
				ThemeManager.STATUS_INFORMATION
			)

		&"crawler":
			event_color = (
				ThemeManager.STATUS_INFORMATION
			)

		&"research":
			event_color = (
				ThemeManager.ACCENT_BLUE
			)

	type_label.add_theme_color_override(
		"font_color",
		event_color
	)
	
func refresh_recent_events_status(
	event_count: int
) -> void:
	if event_count <= 0:
		recent_events_panel.set_status(
			"NO EVENTS",
			ThemeManager.TEXT_DISABLED
		)

		return

	if event_count == 1:
		recent_events_panel.set_status(
			"1 EVENT",
			ThemeManager.STATUS_INFORMATION
		)

		return

	recent_events_panel.set_status(
		"%d EVENTS" % event_count,
		ThemeManager.STATUS_INFORMATION
	)


# -------------------------------------------------------------------
# Objective setup
# -------------------------------------------------------------------

	
func connect_objective_signals() -> void:
	if not ObjectiveManager.objective_changed.is_connected(
		_on_objective_changed
	):
		ObjectiveManager.objective_changed.connect(
			_on_objective_changed
		)

	if not ObjectiveManager.objective_progress_changed.is_connected(
		_on_objective_progress_changed
	):
		ObjectiveManager.objective_progress_changed.connect(
			_on_objective_progress_changed
		)

	if not ObjectiveManager.all_objectives_completed.is_connected(
		_on_all_objectives_completed
	):
		ObjectiveManager.all_objectives_completed.connect(
			_on_all_objectives_completed
		)
		
	if not ObjectiveManager.tier_2_active_objectives_changed.is_connected(
		_on_tier_2_active_objectives_changed
	):
		ObjectiveManager.tier_2_active_objectives_changed.connect(
			_on_tier_2_active_objectives_changed
		)

	if not ObjectiveManager.tier_2_objective_progress_changed.is_connected(
		_on_tier_2_objective_progress_changed
	):
		ObjectiveManager.tier_2_objective_progress_changed.connect(
			_on_tier_2_objective_progress_changed
		)
		
func refresh_current_objective() -> void:
	if ObjectiveManager.is_tier_2_tracking_active():
		current_objective_layout.visible = false
		tier_2_objective_scroll.visible = true

		refresh_tier_2_objectives()

		return

	tier_2_objective_scroll.visible = false
	current_objective_layout.visible = true

	objective_2_container.visible = false

	if ObjectiveManager.sequence_completed:
		_on_all_objectives_completed()

		return

	_on_objective_changed(
		ObjectiveManager.get_current_objective_id(),
		ObjectiveManager.get_current_objective_title(),
		ObjectiveManager.get_current_objective_description(),
		ObjectiveManager.get_current_progress(),
		ObjectiveManager.get_current_objective_target()
	)
	
func _on_objective_changed(
	_objective_id: StringName,
	title: String,
	description: String,
	current_value: int,
	target_value: int
) -> void:
	if ObjectiveManager.is_tier_2_tracking_active():
		refresh_tier_2_objectives()
		return
	objective_title_label.text = title
	objective_description_label.text = description

	current_objective_panel.set_status(
		"ACTIVE",
		ThemeManager.STATUS_INFORMATION
	)

	update_objective_progress(
		current_value,
		target_value
	)
	
func _on_objective_progress_changed(
	current_value: int,
	target_value: int
) -> void:
	update_objective_progress(
		current_value,
		target_value
	)
	
func update_objective_progress(
	current_value: int,
	target_value: int
) -> void:
	if target_value <= 0:
		objective_progress_bar.value = 0.0
		objective_progress_label.text = "0 / 0"
		return

	var progress_percent: float = clampf(
		float(current_value)
		/ float(target_value)
		* 100.0,
		0.0,
		100.0
	)

	objective_progress_bar.min_value = 0.0
	objective_progress_bar.max_value = 100.0
	objective_progress_bar.value = progress_percent

	objective_progress_label.text = (
		"%d / %d"
		% [
			mini(
				current_value,
				target_value
			),
			target_value
		]
	)
	
func _on_all_objectives_completed() -> void:
	objective_title_label.text = (
		"Initial Objectives Complete"
	)

	objective_description_label.text = (
		"All current objectives have been completed."
	)

	objective_progress_bar.value = 100.0

	objective_progress_label.text = (
		"COMPLETE"
	)

	current_objective_panel.set_status(
		"COMPLETE",
		ThemeManager.STATUS_SUCCESS
	)
	
func _on_tier_2_active_objectives_changed() -> void:
	refresh_tier_2_objectives()


func _on_tier_2_objective_progress_changed(
	objective_id: StringName,
	_current_value: float,
	_target_value: float
) -> void:
	if not ObjectiveManager.is_tier_2_tracking_active():
		return

	build_tier_2_objective_rows()

	refresh_tier_2_objective_row(
		objective_id
	)
	
func refresh_tier_2_objectives() -> void:
	current_objective_layout.visible = false
	tier_2_objective_scroll.visible = true

	build_tier_2_objective_rows()

	var completed_count: int = (
		ObjectiveManager.get_tier_2_completed_count()
	)

	var objective_count: int = (
		ObjectiveManager.TIER_2_OBJECTIVE_ORDER.size()
	)

	if ObjectiveManager.is_tier_2_capstone_completed():
		current_objective_panel.set_status(
			"TIER 2 COMPLETE",
			ThemeManager.STATUS_SUCCESS
		)

	elif completed_count >= objective_count:
		current_objective_panel.set_status(
			"%d / %d COMPLETE"
			% [
				completed_count,
				objective_count
			],
			ThemeManager.STATUS_SUCCESS
		)

	else:
		current_objective_panel.set_status(
			"%d / %d COMPLETE"
			% [
				completed_count,
				objective_count
			],
			ThemeManager.STATUS_INFORMATION
		)

	for objective: Dictionary in (
		ObjectiveManager.get_tier_2_all_objectives()
	):
		var objective_id: StringName = StringName(
			objective.get(
				"id",
				&""
			)
		)

		refresh_tier_2_objective_row(
			objective_id
		)

	refresh_tier_2_capstone_row()
	
func build_tier_2_objective_rows() -> void:
	print(
		"Dashboard: Building Tier 2 objective rows."
	)

	print(
		"Dashboard: Tier 2 objective count = ",
		ObjectiveManager.get_tier_2_all_objectives().size()
	)

	print(
		"Dashboard: Scroll size = ",
		tier_2_objective_scroll.size
	)

	print(
		"Dashboard: List size = ",
		tier_2_objective_list.size
	)

	if not tier_2_objective_rows.is_empty():
		print(
			"Dashboard: Rows already exist = ",
			tier_2_objective_rows.size()
		)

		return

	for objective: Dictionary in (
		ObjectiveManager.get_tier_2_all_objectives()
	):
		create_tier_2_objective_row(
			objective
		)

	create_tier_2_capstone_row()
	
func create_tier_2_objective_row(
	objective: Dictionary
) -> void:
	var objective_id: StringName = StringName(
		objective.get(
			"id",
			&""
		)
	)

	if objective_id == &"":
		return

	var row: VBoxContainer = VBoxContainer.new()

	row.name = (
		"Objective_%s"
		% str(objective_id)
	)

	row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	row.add_theme_constant_override(
		"separation",
		3
	)

	var title_row: HBoxContainer = (
		HBoxContainer.new()
	)

	title_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	var title_label: Label = Label.new()

	title_label.text = str(
		objective.get(
			"title",
			"Objective"
		)
	)

	title_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	title_label.add_theme_font_size_override(
		"font_size",
		14
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	var status_label: Label = Label.new()

	status_label.custom_minimum_size = Vector2(
		80.0,
		0.0
	)

	status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	status_label.add_theme_font_size_override(
		"font_size",
		11
	)

	title_row.add_child(
		title_label
	)

	title_row.add_child(
		status_label
	)

	var description_label: Label = Label.new()

	description_label.text = str(
		objective.get(
			"description",
			""
		)
	)

	description_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)

	description_label.add_theme_font_size_override(
		"font_size",
		11
	)

	description_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	var progress_bar: ProgressBar = (
		ProgressBar.new()
	)

	progress_bar.custom_minimum_size = Vector2(
		0.0,
		18.0
	)

	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.show_percentage = false

	var progress_label: Label = Label.new()

	progress_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	progress_label.add_theme_font_size_override(
		"font_size",
		11
	)

	progress_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	row.add_child(
		title_row
	)

	row.add_child(
		description_label
	)

	row.add_child(
		progress_bar
	)

	row.add_child(
		progress_label
	)

	tier_2_objective_list.add_child(
		row
	)

	var separator: HSeparator = HSeparator.new()

	tier_2_objective_list.add_child(
		separator
	)

	tier_2_objective_rows[
		objective_id
	] = {
		"title": title_label,
		"status": status_label,
		"description": description_label,
		"progress_bar": progress_bar,
		"progress_label": progress_label
	}
	
func refresh_tier_2_objective_row(
	objective_id: StringName
) -> void:
	if not tier_2_objective_rows.has(
		objective_id
	):
		return

	var row_nodes: Dictionary = (
		tier_2_objective_rows[
			objective_id
		]
	)

	var title_label: Label = (
		row_nodes.get(
			"title"
		) as Label
	)

	var status_label: Label = (
		row_nodes.get(
			"status"
		) as Label
	)

	var progress_bar: ProgressBar = (
		row_nodes.get(
			"progress_bar"
		) as ProgressBar
	)

	var progress_label: Label = (
		row_nodes.get(
			"progress_label"
		) as Label
	)

	var completed: bool = (
		ObjectiveManager
			.is_tier_2_objective_completed(
				objective_id
			)
	)

	var current_value: float = (
		ObjectiveManager
			.get_tier_2_objective_progress(
				objective_id
			)
	)

	var target_value: float = (
		ObjectiveManager
			.get_tier_2_objective_target(
				objective_id
			)
	)

	if completed:
		status_label.text = "COMPLETE"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)
	else:
		status_label.text = "ACTIVE"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_INFORMATION
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

	if target_value <= 0.0:
		progress_bar.value = 0.0
		progress_label.text = "0 / 0"

		return

	var safe_current: float = minf(
		current_value,
		target_value
	)

	if completed:
		safe_current = target_value

	var progress_percent: float = clampf(
		safe_current
		/ target_value
		* 100.0,
		0.0,
		100.0
	)

	progress_bar.value = progress_percent

	if (
		objective_id
		== ObjectiveManager
			.OBJECTIVE_T2_EARN_250_REVENUE
	):
		progress_label.text = (
			"$%.0f / $%.0f"
			% [
				safe_current,
				target_value
			]
		)

		return

	progress_label.text = (
		"%d / %d"
		% [
			floori(safe_current),
			floori(target_value)
		]
	)
	
func create_tier_2_capstone_row() -> void:
	var capstone_heading: Label = Label.new()

	capstone_heading.text = (
		"TIER 2 CAPSTONE"
	)

	capstone_heading.add_theme_font_size_override(
		"font_size",
		12
	)

	capstone_heading.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	tier_2_objective_list.add_child(
		capstone_heading
	)

	var title_row: HBoxContainer = (
		HBoxContainer.new()
	)

	var title_label: Label = Label.new()

	title_label.text = (
		"Expanded Operations Test"
	)

	title_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	title_label.add_theme_font_size_override(
		"font_size",
		14
	)

	var status_label: Label = Label.new()

	status_label.custom_minimum_size = Vector2(
		80.0,
		0.0
	)

	status_label.horizontal_alignment = (
		HORIZONTAL_ALIGNMENT_RIGHT
	)

	status_label.add_theme_font_size_override(
		"font_size",
		11
	)

	title_row.add_child(
		title_label
	)

	title_row.add_child(
		status_label
	)

	var description_label: Label = Label.new()

	description_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)

	description_label.add_theme_font_size_override(
		"font_size",
		11
	)
	
	description_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	tier_2_objective_list.add_child(
		title_row
	)

	tier_2_objective_list.add_child(
		description_label
	)

	tier_2_capstone_nodes = {
		"title": title_label,
		"status": status_label,
		"description": description_label
	}
	
func refresh_tier_2_capstone_row() -> void:
	if tier_2_capstone_nodes.is_empty():
		return

	var title_label: Label = (
		tier_2_capstone_nodes.get(
			"title"
		) as Label
	)

	var status_label: Label = (
		tier_2_capstone_nodes.get(
			"status"
		) as Label
	)

	var description_label: Label = (
		tier_2_capstone_nodes.get(
			"description"
		) as Label
	)

	if ObjectiveManager.is_tier_2_capstone_completed():
		status_label.text = "COMPLETE"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

		description_label.text = (
			"Expanded Operations Test completed successfully."
		)

		return

	if ObjectiveManager.is_tier_2_capstone_attempt_active():
		status_label.text = "IN PROGRESS"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_INFORMATION
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

		description_label.text = (
			"Expanded Crawl in progress. "
			+ "Avoid triggering a server overload."
		)

		return

	if ObjectiveManager.has_tier_2_capstone_attempt_failed():
		status_label.text = "FAILED"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_ERROR
		)

		description_label.text = (
			"Server overload detected. Finish the current "
			+ "crawl, then start a new Expanded Crawl to retry."
		)

		return

	if (
		ObjectiveManager
			.are_tier_2_standard_objectives_complete()
	):
		status_label.text = "READY"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_WARNING
		)

		title_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

		description_label.text = str(
			ObjectiveManager
				.get_tier_2_capstone_data()
				.get(
					"description",
					""
				)
		)

		return

	status_label.text = "LOCKED"

	status_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_DISABLED
	)

	description_label.text = (
		"Complete all seven standard Tier 2 "
		+ "objectives to unlock."
	)
		
func refresh_tier_2_objective_slot(
	objective: Dictionary,
	title_label: Label,
	description_label: Label,
	progress_bar: ProgressBar,
	progress_label: Label
) -> void:
	var objective_id: StringName = StringName(
		objective.get(
			"id",
			&""
		)
	)

	var title: String = str(
		objective.get(
			"title",
			"Objective"
		)
	)

	var description: String = str(
		objective.get(
			"description",
			""
		)
	)

	var current_value: float = (
		ObjectiveManager.get_tier_2_objective_progress(
			objective_id
		)
	)

	var target_value: float = (
		ObjectiveManager.get_tier_2_objective_target(
			objective_id
		)
	)

	title_label.text = title
	description_label.text = description

	update_tier_2_objective_progress(
		objective_id,
		progress_bar,
		progress_label,
		current_value,
		target_value
	)
	
func update_tier_2_objective_progress(
	objective_id: StringName,
	progress_bar: ProgressBar,
	progress_label: Label,
	current_value: float,
	target_value: float
) -> void:
	if target_value <= 0.0:
		progress_bar.value = 0.0
		progress_label.text = "0 / 0"
		return

	var safe_current: float = minf(
		current_value,
		target_value
	)

	var progress_percent: float = clampf(
		safe_current
		/ target_value
		* 100.0,
		0.0,
		100.0
	)

	progress_bar.min_value = 0.0
	progress_bar.max_value = 100.0
	progress_bar.value = progress_percent

	if (
		objective_id
		== ObjectiveManager.OBJECTIVE_T2_EARN_250_REVENUE
	):
		progress_label.text = (
			"$%.0f / $%.0f"
			% [
				safe_current,
				target_value
			]
		)

		return

	progress_label.text = (
		"%d / %d"
		% [
			floori(safe_current),
			floori(target_value)
		]
	)
	
func show_tier_2_standard_complete_state() -> void:
	objective_2_container.visible = false

	objective_title_label.text = (
		"Tier 2 Standard Objectives Complete"
	)

	objective_description_label.text = (
		"All seven Tier 2 objectives have been completed. "
		+ "The Tier 2 Capstone is ready."
	)

	objective_progress_bar.min_value = 0.0
	objective_progress_bar.max_value = 100.0
	objective_progress_bar.value = 100.0

	objective_progress_label.text = (
		"7 / 7 COMPLETE"
	)

	current_objective_panel.set_status(
		"COMPLETE",
		ThemeManager.STATUS_SUCCESS
	)


# -------------------------------------------------------------------
# GameState signal connections
# -------------------------------------------------------------------

func connect_game_state_signals() -> void:
	if not GameState.revenue_changed.is_connected(
		_on_revenue_changed
	):
		GameState.revenue_changed.connect(
			_on_revenue_changed
		)

	if not GameState.active_users_changed.is_connected(
		_on_active_users_changed
	):
		GameState.active_users_changed.connect(
			_on_active_users_changed
		)

	if not GameState.indexed_pages_changed.is_connected(
		_on_indexed_pages_changed
	):
		GameState.indexed_pages_changed.connect(
			_on_indexed_pages_changed
		)

	if not GameState.server_load_changed.is_connected(
		_on_server_load_changed
	):
		GameState.server_load_changed.connect(
			_on_server_load_changed
		)

	if not GameState.crawler_state_changed.is_connected(
		_on_crawler_state_changed
	):
		GameState.crawler_state_changed.connect(
			_on_crawler_state_changed
		)

	if not GameState.crawler_rate_changed.is_connected(
		_on_crawler_rate_changed
	):
		GameState.crawler_rate_changed.connect(
			_on_crawler_rate_changed
		)

	if not ServerManager.maximum_safe_load_level_changed.is_connected(
		_on_dashboard_maximum_safe_load_level_changed
	):
		ServerManager.maximum_safe_load_level_changed.connect(
			_on_dashboard_maximum_safe_load_level_changed
		)
		
func _on_dashboard_maximum_safe_load_level_changed(
	_new_level: int
) -> void:
	_on_server_load_changed(
		GameState.server_load
	)


# -------------------------------------------------------------------
# Initial Dashboard values
# -------------------------------------------------------------------

func refresh_dashboard() -> void:
	_on_revenue_changed(GameState.revenue)
	_on_active_users_changed(GameState.active_users)
	_on_indexed_pages_changed(GameState.indexed_pages)
	_on_server_load_changed(GameState.server_load)

	_on_crawler_state_changed(
		GameState.crawler_running
	)

	_on_crawler_rate_changed(
		GameState.crawler_rate
	)


# -------------------------------------------------------------------
# Resource updates
# -------------------------------------------------------------------

func _on_revenue_changed(new_value: float) -> void:
	revenue_value_label.text = format_money(new_value)


func _on_active_users_changed(new_value: int) -> void:
	active_users_value_label.text = format_whole_number(
		new_value
	)


func _on_indexed_pages_changed(new_value: int) -> void:
	indexed_pages_value_label.text = format_whole_number(
		new_value
	)

	


# -------------------------------------------------------------------
# Crawler updates
# -------------------------------------------------------------------

func _on_crawler_state_changed(is_running: bool) -> void:
	if is_running:
		crawler_status_value_label.text = "Running"

		crawler_overview.set_status(
			"RUNNING",
			ThemeManager.STATUS_SUCCESS
		)
	else:
		crawler_status_value_label.text = "Offline"

		crawler_overview.set_status(
			"OFFLINE",
			ThemeManager.TEXT_DISABLED
		)


func _on_crawler_rate_changed(new_value: float) -> void:
	crawler_rate_value_label.text = format_crawler_rate(
		new_value
	)


# -------------------------------------------------------------------
# Server updates
# -------------------------------------------------------------------

func _on_server_load_changed(
	new_value: float
) -> void:
	var maximum_safe_load: float = (
		CrawlerManager.get_effective_maximum_safe_load()
	)

	var warning_threshold: float = (
		CrawlerManager.get_effective_warning_threshold()
	)

	var safe_load: float = clampf(
		new_value,
		0.0,
		maximum_safe_load
	)

	var load_usage_percent: float = (
		CrawlerManager.get_server_load_usage_percent(
			safe_load
		)
	)

	server_load_value_label.text = (
		"%d%% / %d%%"
		% [
			roundi(safe_load),
			roundi(maximum_safe_load)
		]
	)

	server_load_progress.min_value = 0.0
	server_load_progress.max_value = 100.0
	server_load_progress.value = load_usage_percent

	update_server_load_progress_color(
		load_usage_percent
	)

	if safe_load >= maximum_safe_load:
		server_health_value_label.text = "Critical"

		server_overview.set_status(
			"CRITICAL",
			ThemeManager.STATUS_ERROR
		)

	elif safe_load >= warning_threshold:
		server_health_value_label.text = "Warning"

		server_overview.set_status(
			"WARNING",
			ThemeManager.STATUS_WARNING
		)

	else:
		server_health_value_label.text = "Normal"

		server_overview.set_status(
			"NORMAL",
			ThemeManager.STATUS_SUCCESS
		)
		
func update_server_load_progress_color(
	load_usage_percent: float
) -> void:
	var safe_percent: float = clampf(
		load_usage_percent,
		0.0,
		100.0
	)

	var load_color: Color

	if safe_percent <= 50.0:
		var transition: float = (
			safe_percent / 50.0
		)

		load_color = (
			ThemeManager.STATUS_SUCCESS.lerp(
				ThemeManager.STATUS_WARNING,
				transition
			)
		)

	else:
		var transition: float = (
			(safe_percent - 50.0)
			/ 50.0
		)

		load_color = (
			ThemeManager.STATUS_WARNING.lerp(
				ThemeManager.STATUS_ERROR,
				transition
			)
		)

	var current_fill_style: StyleBox = (
		server_load_progress.get_theme_stylebox(
			"fill"
		)
	)

	var fill_style: StyleBoxFlat

	if current_fill_style is StyleBoxFlat:
		fill_style = (
			current_fill_style.duplicate()
			as StyleBoxFlat
		)
	else:
		fill_style = StyleBoxFlat.new()

	fill_style.bg_color = load_color

	server_load_progress.add_theme_stylebox_override(
		"fill",
		fill_style
	)


# -------------------------------------------------------------------
# Objective updates
# -------------------------------------------------------------------



# -------------------------------------------------------------------
# Formatting
# -------------------------------------------------------------------

func format_money(value: float) -> String:
	var safe_value: float = maxf(value, 0.0)
	var total_cents: int = roundi(safe_value * 100.0)

	var whole_dollars: int = total_cents / 100
	var cents: int = total_cents % 100

	return "$%s.%02d" % [
		format_whole_number(whole_dollars),
		cents
	]


func format_whole_number(value: int) -> String:
	var number_text: String = str(
		maxi(value, 0)
	)

	var formatted_text: String = ""

	while number_text.length() > 3:
		var split_index: int = number_text.length() - 3

		formatted_text = (
			","
			+ number_text.substr(split_index, 3)
			+ formatted_text
		)

		number_text = number_text.substr(
			0,
			split_index
		)

	return number_text + formatted_text


func format_percentage(value: float) -> String:
	return "%d%%" % roundi(
		clampf(value, 0.0, 100.0)
	)


func format_crawler_rate(value: float) -> String:
	var safe_value: float = maxf(value, 0.0)
	var rounded_value: int = roundi(safe_value)

	if is_equal_approx(
		safe_value,
		float(rounded_value)
	):
		if rounded_value == 1:
			return "1 page/sec"

		return "%d pages/sec" % rounded_value

	return "%.2f pages/sec" % safe_value
