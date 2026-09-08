extends PanelContainer


# -------------------------------------------------------------------
# Page Header
# -------------------------------------------------------------------

@onready var crawler_jobs_page_title_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/CrawlerJobsPageTitleLayout/"
	+ "CrawlerJobsPageTitleLabel"
) as Label

@onready var crawler_jobs_page_subtitle_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/CrawlerJobsPageTitleLayout/"
	+ "CrawlerJobsPageSubtitleLabel"
) as Label

@onready var crawler_jobs_page_status_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageHeader/"
	+ "CrawlerJobsPageStatusLabel"
) as Label


# -------------------------------------------------------------------
# Available Crawls
# -------------------------------------------------------------------

@onready var available_crawls_panel: PanelContainer = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/AvailableCrawlsPanel"
) as PanelContainer

@onready var available_crawls_header_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/AvailableCrawlsPanel/"
	+ "AvailableCrawlsPanelLayout/"
	+ "AvailableCrawlsHeaderLabel"
) as Label

@onready var available_crawls_info_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/AvailableCrawlsPanel/"
	+ "AvailableCrawlsPanelLayout/"
	+ "AvailableCrawlsInfoLabel"
) as Label

@onready var available_crawls_list: VBoxContainer = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/AvailableCrawlsPanel/"
	+ "AvailableCrawlsPanelLayout/AvailableCrawlsScroll/"
	+ "AvailableCrawlsList"
) as VBoxContainer


# -------------------------------------------------------------------
# Quick Crawls
# -------------------------------------------------------------------

@onready var quick_crawls_panel: PanelContainer = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel"
) as PanelContainer

@onready var quick_crawls_header_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel/QuickCrawlsPanelLayout/"
	+ "QuickCrawlsHeaderLabel"
) as Label

@onready var quick_crawls_info_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel/QuickCrawlsPanelLayout/"
	+ "QuickCrawlsInfoLabel"
) as Label

@onready var quick_crawl_slot_1_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel/QuickCrawlsPanelLayout/"
	+ "QuickCrawlSlot1Label"
) as Label

@onready var quick_crawl_slot_2_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel/QuickCrawlsPanelLayout/"
	+ "QuickCrawlSlot2Label"
) as Label

@onready var quick_crawl_slot_3_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "QuickCrawlsPanel/QuickCrawlsPanelLayout/"
	+ "QuickCrawlSlot3Label"
) as Label


# -------------------------------------------------------------------
# Scheduler Queue
# -------------------------------------------------------------------

@onready var scheduler_management_panel: PanelContainer = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "SchedulerManagementPanel"
) as PanelContainer

@onready var scheduler_header_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "SchedulerManagementPanel/SchedulerManagementLayout/"
	+ "SchedulerHeaderLabel"
) as Label

@onready var scheduler_summary_label: Label = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "SchedulerManagementPanel/SchedulerManagementLayout/"
	+ "SchedulerSummaryLabel"
) as Label

@onready var scheduler_queue_list: VBoxContainer = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "SchedulerManagementPanel/SchedulerManagementLayout/"
	+ "SchedulerQueueScroll/SchedulerQueueList"
) as VBoxContainer

@onready var clear_scheduler_queue_button: Button = get_node(
	"CrawlerJobsMargin/CrawlerJobsPageLayout/"
	+ "CrawlerJobsPageBody/CrawlerJobsRightColumn/"
	+ "SchedulerManagementPanel/SchedulerManagementLayout/"
	+ "ClearSchedulerQueueButton"
) as Button


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	apply_page_theme()
	connect_crawler_job_signals()
	connect_buttons()

	refresh_jobs_page()


func connect_crawler_job_signals() -> void:
	if not CrawlerManager.quick_crawl_jobs_changed.is_connected(
		_on_quick_crawl_jobs_changed
	):
		CrawlerManager.quick_crawl_jobs_changed.connect(
			_on_quick_crawl_jobs_changed
		)

	if not CrawlerManager.crawl_job_queue_changed.is_connected(
		_on_crawl_job_queue_changed
	):
		CrawlerManager.crawl_job_queue_changed.connect(
			_on_crawl_job_queue_changed
		)

	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)


func connect_buttons() -> void:
	if not clear_scheduler_queue_button.pressed.is_connected(
		_on_clear_scheduler_queue_button_pressed
	):
		clear_scheduler_queue_button.pressed.connect(
			_on_clear_scheduler_queue_button_pressed
		)


# -------------------------------------------------------------------
# Theme
# -------------------------------------------------------------------

func apply_page_theme() -> void:
	add_theme_stylebox_override(
		"panel",
		ThemeManager.create_page_background_style()
	)

	available_crawls_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_panel_style()
	)

	quick_crawls_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_panel_style()
	)

	scheduler_management_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_section_panel_style()
	)

	crawler_jobs_page_title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	crawler_jobs_page_title_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_TITLE
	)

	crawler_jobs_page_subtitle_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	crawler_jobs_page_subtitle_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	var header_labels: Array[Label] = [
		available_crawls_header_label,
		quick_crawls_header_label,
		scheduler_header_label
	]

	for header_label: Label in header_labels:
		header_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_PRIMARY
		)

		header_label.add_theme_font_size_override(
			"font_size",
			ThemeManager.FONT_SIZE_SECTION_HEADER
		)

	available_crawls_info_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	quick_crawls_info_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	available_crawls_info_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	quick_crawls_info_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)


# -------------------------------------------------------------------
# Main Refresh
# -------------------------------------------------------------------

func refresh_jobs_page() -> void:
	refresh_available_crawls()
	refresh_quick_crawls()
	refresh_scheduler_queue()
	refresh_page_status()


# -------------------------------------------------------------------
# Available Crawl Catalog
# -------------------------------------------------------------------

func refresh_available_crawls() -> void:
	clear_container_children(
		available_crawls_list
	)

	var job_ids: Array[StringName] = (
		CrawlerManager.get_all_crawl_job_ids()
	)

	for job_id: StringName in job_ids:
		add_available_crawl_entry(
			job_id
		)


func add_available_crawl_entry(
	job_id: StringName
) -> void:
	var unlocked: bool = (
		CrawlerManager.is_crawl_job_unlocked(
			job_id
		)
	)

	var job_name: String = (
		CrawlerManager.get_job_display_name(
			job_id
		)
	)

	var description: String = (
		CrawlerManager.get_crawl_job_description(
			job_id
		)
	)

	var target_pages: int = (
		CrawlerManager.get_job_target_pages(
			job_id
		)
	)

	var required_tier: int = (
		CrawlerManager.get_crawl_job_required_tier(
			job_id
		)
	)

	var entry_panel: PanelContainer = PanelContainer.new()

	entry_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	entry_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_dashboard_inset_style()
	)

	var entry_layout: VBoxContainer = VBoxContainer.new()

	entry_layout.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	entry_panel.add_child(
		entry_layout
	)

	var title_row: HBoxContainer = HBoxContainer.new()

	title_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	entry_layout.add_child(
		title_row
	)

	var title_label: Label = Label.new()

	title_label.text = job_name

	title_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	title_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	title_row.add_child(
		title_label
	)

	var status_label: Label = Label.new()

	if unlocked:
		status_label.text = "AVAILABLE"

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.STATUS_SUCCESS
		)

	else:
		status_label.text = (
			"TIER %d"
			% required_tier
		)

		status_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

	title_row.add_child(
		status_label
	)

	var description_label: Label = Label.new()

	description_label.text = description

	description_label.autowrap_mode = (
		TextServer.AUTOWRAP_WORD_SMART
	)

	description_label.max_lines_visible = 2

	description_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	description_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	entry_layout.add_child(
		description_label
	)

	var action_row: HBoxContainer = HBoxContainer.new()

	action_row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	entry_layout.add_child(
		action_row
	)

	var metadata_label: Label = Label.new()

	metadata_label.text = (
		"%d pages | Tier %d"
		% [
			target_pages,
			required_tier
		]
	)

	metadata_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	metadata_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_SECONDARY
	)

	metadata_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	action_row.add_child(
		metadata_label
	)

	for slot_index: int in range(
		CrawlerManager.QUICK_CRAWL_SLOT_COUNT
	):
		var quick_button: Button = Button.new()

		var current_slot: int = (
			CrawlerManager.get_crawl_job_quick_slot(
				job_id
			)
		)

		if current_slot == slot_index:
			quick_button.text = (
				"Q%d ✓"
				% (slot_index + 1)
			)

			quick_button.disabled = true

		else:
			quick_button.text = (
				"Q%d"
				% (slot_index + 1)
			)

			quick_button.disabled = (
				not unlocked
			)

		quick_button.tooltip_text = (
			"Assign %s to Quick Crawl slot %d."
			% [
				job_name,
				slot_index + 1
			]
		)

		quick_button.pressed.connect(
			_on_assign_quick_crawl_pressed.bind(
				slot_index,
				job_id
			)
		)

		action_row.add_child(
			quick_button
		)

	var queue_button: Button = Button.new()

	queue_button.text = "+ Queue"

	queue_button.disabled = (
		not CrawlerManager.can_add_crawl_job_to_queue(
			job_id
		)
	)

	queue_button.tooltip_text = (
		"Add %s to the scheduler queue."
		% job_name
	)

	queue_button.pressed.connect(
		_on_add_crawl_to_queue_pressed.bind(
			job_id
		)
	)

	action_row.add_child(
		queue_button
	)

	available_crawls_list.add_child(
		entry_panel
	)


# -------------------------------------------------------------------
# Quick Crawl Display
# -------------------------------------------------------------------

func refresh_quick_crawls() -> void:
	refresh_quick_crawl_label(
		quick_crawl_slot_1_label,
		0
	)

	refresh_quick_crawl_label(
		quick_crawl_slot_2_label,
		1
	)

	refresh_quick_crawl_label(
		quick_crawl_slot_3_label,
		2
	)


func refresh_quick_crawl_label(
	target_label: Label,
	slot_index: int
) -> void:
	var job_id: StringName = (
		CrawlerManager.get_quick_crawl_job_id(
			slot_index
		)
	)

	if job_id == &"":
		target_label.text = (
			"%d. EMPTY"
			% (slot_index + 1)
		)

		target_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		return

	var job_name: String = (
		CrawlerManager.get_job_display_name(
			job_id
		)
	)

	var target_pages: int = (
		CrawlerManager.get_job_target_pages(
			job_id
		)
	)

	var unlocked: bool = (
		CrawlerManager.is_crawl_job_unlocked(
			job_id
		)
	)

	target_label.text = (
		"%d. %s — %d pages%s"
		% [
			slot_index + 1,
			job_name,
			target_pages,
			"" if unlocked else " — LOCKED"
		]
	)

	target_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
		if unlocked
		else ThemeManager.TEXT_DISABLED
	)


# -------------------------------------------------------------------
# Scheduler Queue Display
# -------------------------------------------------------------------

func refresh_scheduler_queue() -> void:
	clear_container_children(
		scheduler_queue_list
	)

	var queue: Array[StringName] = (
		CrawlerManager.get_crawl_job_queue()
	)

	scheduler_summary_label.text = (
		"Queue: %d / %d"
		% [
			queue.size(),
			CrawlerManager.MAX_CRAWL_JOB_QUEUE_SIZE
		]
	)

	clear_scheduler_queue_button.disabled = (
		queue.is_empty()
	)

	if queue.is_empty():
		var empty_label: Label = Label.new()

		empty_label.text = (
			"No crawl jobs are currently queued."
		)

		empty_label.add_theme_color_override(
			"font_color",
			ThemeManager.TEXT_DISABLED
		)

		scheduler_queue_list.add_child(
			empty_label
		)

		return

	for queue_index: int in range(
		queue.size()
	):
		add_scheduler_queue_entry(
			queue_index,
			queue[queue_index],
			queue.size()
		)


func add_scheduler_queue_entry(
	queue_index: int,
	job_id: StringName,
	queue_size: int
) -> void:
	var row_panel: PanelContainer = PanelContainer.new()

	row_panel.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	row_panel.add_theme_stylebox_override(
		"panel",
		ThemeManager.create_dashboard_metric_style()
	)

	var row: HBoxContainer = HBoxContainer.new()

	row.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	row_panel.add_child(
		row
	)

	var index_label: Label = Label.new()

	index_label.text = (
		"%d."
		% (queue_index + 1)
	)

	row.add_child(
		index_label
	)

	var name_label: Label = Label.new()

	name_label.text = (
		CrawlerManager.get_job_display_name(
			job_id
		)
	)

	name_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	name_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	row.add_child(
		name_label
	)

	var up_button: Button = Button.new()

	up_button.text = "↑"

	up_button.disabled = (
		queue_index <= 0
	)

	up_button.tooltip_text = "Move job up."

	up_button.pressed.connect(
		_on_move_queue_job_pressed.bind(
			queue_index,
			queue_index - 1
		)
	)

	row.add_child(
		up_button
	)

	var down_button: Button = Button.new()

	down_button.text = "↓"

	down_button.disabled = (
		queue_index >= queue_size - 1
	)

	down_button.tooltip_text = "Move job down."

	down_button.pressed.connect(
		_on_move_queue_job_pressed.bind(
			queue_index,
			queue_index + 1
		)
	)

	row.add_child(
		down_button
	)

	var remove_button: Button = Button.new()

	remove_button.text = "X"

	remove_button.tooltip_text = (
		"Remove job from queue."
	)

	remove_button.pressed.connect(
		_on_remove_queue_job_pressed.bind(
			queue_index
		)
	)

	row.add_child(
		remove_button
	)

	scheduler_queue_list.add_child(
		row_panel
	)


# -------------------------------------------------------------------
# Page Status
# -------------------------------------------------------------------

func refresh_page_status() -> void:
	var unlocked_count: int = 0

	var job_ids: Array[StringName] = (
		CrawlerManager.get_all_crawl_job_ids()
	)

	for job_id: StringName in job_ids:
		if CrawlerManager.is_crawl_job_unlocked(
			job_id
		):
			unlocked_count += 1

	var queue_size: int = (
		CrawlerManager.get_crawl_job_queue_size()
	)

	crawler_jobs_page_status_label.text = (
		"%d UNLOCKED | %d QUEUED"
		% [
			unlocked_count,
			queue_size
		]
	)

	crawler_jobs_page_status_label.add_theme_color_override(
		"font_color",
		ThemeManager.STATUS_INFORMATION
	)


# -------------------------------------------------------------------
# Button Callbacks
# -------------------------------------------------------------------

func _on_assign_quick_crawl_pressed(
	slot_index: int,
	job_id: StringName
) -> void:
	if not CrawlerManager.is_crawl_job_unlocked(
		job_id
	):
		return

	CrawlerManager.set_quick_crawl_job(
		slot_index,
		job_id
	)


func _on_add_crawl_to_queue_pressed(
	job_id: StringName
) -> void:
	CrawlerManager.add_crawl_job_to_queue(
		job_id
	)


func _on_move_queue_job_pressed(
	from_index: int,
	to_index: int
) -> void:
	CrawlerManager.move_crawl_job_in_queue(
		from_index,
		to_index
	)


func _on_remove_queue_job_pressed(
	queue_index: int
) -> void:
	CrawlerManager.remove_crawl_job_from_queue(
		queue_index
	)


func _on_clear_scheduler_queue_button_pressed() -> void:
	CrawlerManager.clear_crawl_job_queue()


# -------------------------------------------------------------------
# Manager Signal Callbacks
# -------------------------------------------------------------------

func _on_quick_crawl_jobs_changed() -> void:
	refresh_available_crawls()
	refresh_quick_crawls()


func _on_crawl_job_queue_changed() -> void:
	refresh_available_crawls()
	refresh_scheduler_queue()
	refresh_page_status()


func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	refresh_jobs_page()


# -------------------------------------------------------------------
# Utility
# -------------------------------------------------------------------

func clear_container_children(
	container: Container
) -> void:
	for child: Node in container.get_children():
		container.remove_child(
			child
		)

		child.queue_free()
