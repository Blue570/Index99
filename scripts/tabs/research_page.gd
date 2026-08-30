extends PanelContainer


# -------------------------------------------------------------------
# Research Overview
# -------------------------------------------------------------------

@onready var research_points_value_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchSummaryRow/"
	+ "ResearchOverviewPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ResearchOverviewLayout/"
	+ "ResearchPointsRow/"
	+ "ResearchPointsValueLabel"
) as Label

# -------------------------------------------------------------------
# Available Research
# -------------------------------------------------------------------

@onready var available_research_panel: SectionPanel = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel"
) as SectionPanel


# Crawler Optimization

@onready var crawler_optimization_level_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationResearchRow/"
	+ "CrawlerOptimizationLevelLabel"
) as Label

@onready var crawler_optimization_cost_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationResearchRow/"
	+ "CrawlerOptimizationCostLabel"
) as Label

@onready var crawler_optimization_max_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationResearchRow/"
	+ "CrawlerOptimizationMaxLabel"
) as Label

@onready var crawler_optimization_current_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationCurrentEffectLabel"
) as Label

@onready var crawler_optimization_next_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationNextEffectLabel"
) as Label


# Search Monetization

@onready var search_monetization_level_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationResearchRow/"
	+ "SearchMonetizationLevelLabel"
) as Label

@onready var search_monetization_cost_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationResearchRow/"
	+ "SearchMonetizationCostLabel"
) as Label

@onready var search_monetization_max_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationResearchRow/"
	+ "SearchMonetizationMaxLabel"
) as Label

@onready var search_monetization_current_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationCurrentEffectLabel"
) as Label

@onready var search_monetization_next_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationNextEffectLabel"
) as Label


# Audience Discovery

@onready var audience_discovery_level_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryResearchRow/"
	+ "AudienceDiscoveryLevelLabel"
) as Label

@onready var audience_discovery_cost_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryResearchRow/"
	+ "AudienceDiscoveryCostLabel"
) as Label

@onready var audience_discovery_max_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryResearchRow/"
	+ "AudienceDiscoveryMaxLabel"
) as Label

@onready var audience_discovery_current_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryCurrentEffectLabel"
) as Label

@onready var audience_discovery_next_effect_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryNextEffectLabel"
) as Label

# -------------------------------------------------------------------
# Research Effects
# -------------------------------------------------------------------

@onready var research_effects_panel: SectionPanel = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchSummaryRow/ResearchEffectsPanel"
) as SectionPanel

@onready var crawler_speed_effect_value_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchSummaryRow/ResearchEffectsPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ResearchEffectsLayout/"
	+ "CrawlerSpeedEffectRow/"
	+ "CrawlerSpeedEffectValueLabel"
) as Label

@onready var revenue_effect_value_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchSummaryRow/ResearchEffectsPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ResearchEffectsLayout/"
	+ "RevenueEffectRow/"
	+ "RevenueEffectValueLabel"
) as Label

@onready var active_user_effect_value_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchSummaryRow/ResearchEffectsPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "ResearchEffectsLayout/"
	+ "ActiveUserEffectRow/"
	+ "ActiveUserEffectValueLabel"
) as Label

# -------------------------------------------------------------------
# Research Purchase Buttons
# -------------------------------------------------------------------

@onready var crawler_optimization_purchase_button: Button = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "CrawlerOptimizationResearchRow/"
	+ "CrawlerOptimizationPurchaseButton"
) as Button

@onready var search_monetization_purchase_button: Button = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "SearchMonetizationResearchRow/"
	+ "SearchMonetizationPurchaseButton"
) as Button

@onready var audience_discovery_purchase_button: Button = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/AvailableResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "AvailableResearchLayout/"
	+ "AudienceDiscoveryResearchRow/"
	+ "AudienceDiscoveryPurchaseButton"
) as Button

# -------------------------------------------------------------------
# Completed Research
# -------------------------------------------------------------------

@onready var completed_research_panel: SectionPanel = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/CompletedResearchPanel"
) as SectionPanel

@onready var completed_research_summary_value_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/CompletedResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CompletedResearchLayout/"
	+ "CompletedResearchSummaryRow/"
	+ "CompletedResearchSummaryValueLabel"
) as Label

@onready var completed_research_entries: VBoxContainer = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/CompletedResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CompletedResearchLayout/"
	+ "CompletedResearchScrollContainer/"
	+ "CompletedResearchEntries"
) as VBoxContainer

@onready var completed_research_empty_label: Label = get_node(
	"ResearchMargin/ResearchPageLayout/"
	+ "ResearchListsRow/CompletedResearchPanel/"
	+ "PanelLayout/ContentPanel/"
	+ "ContentMargin/ContentContainer/"
	+ "CompletedResearchLayout/"
	+ "CompletedResearchScrollContainer/"
	+ "CompletedResearchEntries/"
	+ "CompletedResearchEmptyLabel"
) as Label


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_research_signals()
	connect_progression_signals()
	connect_research_purchase_buttons()

	refresh_research_points()
	refresh_research_upgrades()
	refresh_research_effects()
	refresh_completed_research()


func connect_research_signals() -> void:
	if not ResearchManager.research_points_changed.is_connected(
		_on_research_points_changed
	):
		ResearchManager.research_points_changed.connect(
			_on_research_points_changed
		)

	if not ResearchManager.research_upgrade_level_changed.is_connected(
		_on_research_upgrade_level_changed
	):
		ResearchManager.research_upgrade_level_changed.connect(
			_on_research_upgrade_level_changed
		)
		
func connect_progression_signals() -> void:
	if not ObjectiveManager.progression_tier_changed.is_connected(
		_on_progression_tier_changed
	):
		ObjectiveManager.progression_tier_changed.connect(
			_on_progression_tier_changed
		)

	if not ObjectiveManager.objective_changed.is_connected(
		_on_objective_changed
	):
		ObjectiveManager.objective_changed.connect(
			_on_objective_changed
		)
		
func _on_objective_changed(
	_objective_id: StringName,
	_title: String,
	_description: String,
	_current_value: int,
	_target_value: int
) -> void:
	refresh_research_upgrades()
		
func _on_progression_tier_changed(
	_new_tier: int
) -> void:
	refresh_research_upgrades()
		
func connect_research_purchase_buttons() -> void:
	if not crawler_optimization_purchase_button.pressed.is_connected(
		_on_crawler_optimization_purchase_pressed
	):
		crawler_optimization_purchase_button.pressed.connect(
			_on_crawler_optimization_purchase_pressed
		)

	if not search_monetization_purchase_button.pressed.is_connected(
		_on_search_monetization_purchase_pressed
	):
		search_monetization_purchase_button.pressed.connect(
			_on_search_monetization_purchase_pressed
		)

	if not audience_discovery_purchase_button.pressed.is_connected(
		_on_audience_discovery_purchase_pressed
	):
		audience_discovery_purchase_button.pressed.connect(
			_on_audience_discovery_purchase_pressed
		)
		
func _on_crawler_optimization_purchase_pressed() -> void:
	attempt_research_purchase(
		ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
	)


func _on_search_monetization_purchase_pressed() -> void:
	attempt_research_purchase(
		ResearchManager.UPGRADE_SEARCH_MONETIZATION
	)


func _on_audience_discovery_purchase_pressed() -> void:
	attempt_research_purchase(
		ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
	)
	
func attempt_research_purchase(
	upgrade_id: StringName
) -> void:
	var purchase_successful: bool = (
		ResearchManager.purchase_upgrade(
			upgrade_id
		)
	)

	if not purchase_successful:
		refresh_research_upgrades()
		return

	refresh_research_upgrades()
	refresh_research_effects()
	refresh_completed_research()
	
func refresh_research_purchase_button(
	upgrade_id: StringName,
	purchase_button: Button
) -> void:
	purchase_button.tooltip_text = ""
	# ---------------------------------------------------------------
	# STATE 1 — RESEARCH TYPE LOCKED
	# ---------------------------------------------------------------

	if not ResearchManager.is_upgrade_unlocked(
		upgrade_id
	):
		purchase_button.text = "LOCKED"
		purchase_button.disabled = true
		return

	# ---------------------------------------------------------------
	# STATE 2 — TRUE MAXIMUM
	# ---------------------------------------------------------------

	if ResearchManager.is_upgrade_maxed(
		upgrade_id
	):
		purchase_button.text = "MAX"
		purchase_button.disabled = true
		return

	# ---------------------------------------------------------------
	# STATE 3 — EARLY PROGRESSION LOCK
	# ---------------------------------------------------------------

	if not ResearchManager.is_next_upgrade_level_unlocked(
		upgrade_id
	):
		purchase_button.text = "TIER 2 LOCKED"
		purchase_button.disabled = true
		return
		
	# ---------------------------------------------------------------
	# STATE 4 — NEXT LEVEL LOCKED BY PROGRESSION
	# ---------------------------------------------------------------

	if not ResearchManager.is_research_purchase_allowed():
		purchase_button.text = "LOCKED"
		purchase_button.disabled = true

		purchase_button.tooltip_text = (
			"Additional research purchasing unlocks when the "
			+ "\"Complete a Research Upgrade\" objective "
			+ "becomes active."
		)

		return

	# ---------------------------------------------------------------
	# STATE 5 — NORMAL RESEARCH
	# ---------------------------------------------------------------

	purchase_button.text = "Research"

	purchase_button.disabled = (
		not ResearchManager.can_afford_upgrade(
			upgrade_id
		)
	)


func refresh_research_points() -> void:
	_on_research_points_changed(
		ResearchManager.research_points
	)
	
func _on_research_upgrade_level_changed(
	_upgrade_id: StringName,
	_new_level: int
) -> void:
	refresh_research_upgrades()
	refresh_research_effects()
	refresh_completed_research()
	
func refresh_research_effects() -> void:
	var crawler_bonus: float = (
		ResearchManager.get_crawler_optimization_bonus()
	)

	var revenue_bonus: float = (
		ResearchManager
		.get_search_monetization_bonus_percent()
	)

	var audience_bonus: float = (
		ResearchManager
		.get_audience_discovery_bonus_percent()
	)

	crawler_speed_effect_value_label.text = (
		"+%.2f pages/sec"
		% crawler_bonus
	)

	revenue_effect_value_label.text = (
		"+%d%%"
		% roundi(revenue_bonus)
	)

	active_user_effect_value_label.text = (
		"+%d%%"
		% roundi(audience_bonus)
	)

	var active_effect_count: int = 0

	if crawler_bonus > 0.0:
		active_effect_count += 1

	if revenue_bonus > 0.0:
		active_effect_count += 1

	if audience_bonus > 0.0:
		active_effect_count += 1

	if active_effect_count <= 0:
		research_effects_panel.set_status(
			"NO EFFECTS",
			ThemeManager.TEXT_DISABLED
		)

	else:
		research_effects_panel.set_status(
			"%d ACTIVE" % active_effect_count,
			ThemeManager.STATUS_SUCCESS
		)
	
func refresh_research_upgrades() -> void:
	refresh_crawler_optimization()
	refresh_search_monetization()
	refresh_audience_discovery()

	refresh_available_research_status()
	
func refresh_available_research_status() -> void:
	if not ResearchManager.is_research_purchase_allowed():
		available_research_panel.set_status(
			"PROGRESSION LOCKED",
			ThemeManager.TEXT_DISABLED
		)

		return
		
	var available_count: int = 0
	var tier_locked_count: int = 0
	var maxed_count: int = 0

	var upgrade_ids: Array[StringName] = [
		ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION,
		ResearchManager.UPGRADE_SEARCH_MONETIZATION,
		ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
	]

	for upgrade_id: StringName in upgrade_ids:
		if not ResearchManager.is_upgrade_unlocked(
			upgrade_id
		):
			continue

		if ResearchManager.is_upgrade_maxed(
			upgrade_id
		):
			maxed_count += 1
			continue

		if not ResearchManager.is_next_upgrade_level_unlocked(
			upgrade_id
		):
			tier_locked_count += 1
			continue

		available_count += 1

	if available_count > 0:
		available_research_panel.set_status(
			"%d AVAILABLE" % available_count,
			ThemeManager.STATUS_INFORMATION
		)

		return

	if tier_locked_count > 0:
		available_research_panel.set_status(
			"TIER 2 LOCKED",
			ThemeManager.STATUS_WARNING
		)

		return

	if maxed_count >= upgrade_ids.size():
		available_research_panel.set_status(
			"ALL COMPLETE",
			ThemeManager.STATUS_SUCCESS
		)

		return

	available_research_panel.set_status(
		"NO RESEARCH",
		ThemeManager.TEXT_DISABLED
	)
	
func refresh_completed_research() -> void:
	clear_completed_research_entries()

	var completed_level_count: int = 0

	var upgrade_ids: Array[StringName] = [
		ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION,
		ResearchManager.UPGRADE_SEARCH_MONETIZATION,
		ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
	]

	for upgrade_id: StringName in upgrade_ids:
		var current_level: int = (
			ResearchManager.get_upgrade_level(
				upgrade_id
			)
		)

		for level_number in range(
			1,
			current_level + 1
		):
			add_completed_research_entry(
				upgrade_id,
				level_number
			)

			completed_level_count += 1

	completed_research_summary_value_label.text = (
		str(completed_level_count)
	)

	if completed_level_count <= 0:
		completed_research_empty_label.visible = true

		completed_research_panel.set_status(
			"EMPTY",
			ThemeManager.TEXT_DISABLED
		)

		return

	completed_research_empty_label.visible = false

	completed_research_panel.set_status(
		"%d COMPLETE"
		% completed_level_count,
		ThemeManager.STATUS_SUCCESS
	)
	
func clear_completed_research_entries() -> void:
	for child: Node in completed_research_entries.get_children():
		if child == completed_research_empty_label:
			continue

		completed_research_entries.remove_child(
			child
		)

		child.queue_free()
		
func add_completed_research_entry(
	upgrade_id: StringName,
	level_number: int
) -> void:
	var entry_label: Label = Label.new()

	entry_label.text = (
		"%s — Level %d — %s"
		% [
			ResearchManager.get_upgrade_name(
				upgrade_id
			),
			level_number,
			get_completed_research_effect_text(
				upgrade_id,
				level_number
			)
		]
	)

	entry_label.size_flags_horizontal = (
		Control.SIZE_EXPAND_FILL
	)

	entry_label.add_theme_font_size_override(
		"font_size",
		ThemeManager.FONT_SIZE_SMALL
	)

	entry_label.add_theme_color_override(
		"font_color",
		ThemeManager.TEXT_PRIMARY
	)

	completed_research_entries.add_child(
		entry_label
	)
	
func get_completed_research_effect_text(
	upgrade_id: StringName,
	level_number: int
) -> String:
	if (
		upgrade_id
		== ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
	):
		var crawler_bonus: float = (
			float(level_number)
			* ResearchManager.CRAWLER_RATE_BONUS_PER_LEVEL
		)

		return (
			"+%.2f pages/sec"
			% crawler_bonus
		)

	if (
		upgrade_id
		== ResearchManager.UPGRADE_SEARCH_MONETIZATION
	):
		var revenue_bonus: float = (
			float(level_number)
			* ResearchManager
			.REVENUE_BONUS_PERCENT_PER_LEVEL
		)

		return (
			"+%d%% revenue"
			% roundi(revenue_bonus)
		)

	if (
		upgrade_id
		== ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
	):
		var audience_bonus: float = (
			float(level_number)
			* ResearchManager
			.ACTIVE_USER_BONUS_PERCENT_PER_LEVEL
		)

		return (
			"+%d%% user growth"
			% roundi(audience_bonus)
		)

	return "Completed"
	
func refresh_crawler_optimization() -> void:
	var upgrade_id: StringName = (
		ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
	)
	
	refresh_research_purchase_button(
		upgrade_id,
		crawler_optimization_purchase_button
	)

	var current_level: int = (
		ResearchManager.get_upgrade_level(
			upgrade_id
		)
	)

	var maximum_level: int = (
		ResearchManager.get_upgrade_maximum_level()
	)

	var current_bonus: float = (
		ResearchManager.get_crawler_optimization_bonus()
	)

	crawler_optimization_level_label.text = (
		"Level %d" % current_level
	)

	crawler_optimization_max_label.text = (
		"Level %d" % maximum_level
	)

	crawler_optimization_current_effect_label.text = (
		"Current Effect: +%.2f pages/sec"
		% current_bonus
	)

	if ResearchManager.is_upgrade_maxed(
		upgrade_id
	):
		crawler_optimization_cost_label.text = "—"

		crawler_optimization_next_effect_label.text = (
			"Next Effect: MAXIMUM LEVEL"
		)

		return
		
	if not ResearchManager.is_next_upgrade_level_unlocked(
		upgrade_id
	):
		crawler_optimization_cost_label.text = "—"

		crawler_optimization_next_effect_label.text = (
			"Next Effect: Tier 2 Required"
		)

		return

	var upgrade_cost: float = (
		ResearchManager.get_upgrade_cost(
			upgrade_id
		)
	)

	var next_bonus: float = (
		float(current_level + 1)
		* ResearchManager.CRAWLER_RATE_BONUS_PER_LEVEL
	)

	crawler_optimization_cost_label.text = (
		format_research_cost(
			upgrade_cost
		)
	)

	crawler_optimization_next_effect_label.text = (
		"Next Effect: +%.2f pages/sec"
		% next_bonus
	)
	
func refresh_search_monetization() -> void:
	var upgrade_id: StringName = (
		ResearchManager.UPGRADE_SEARCH_MONETIZATION
	)
	
	refresh_research_purchase_button(
		upgrade_id,
		search_monetization_purchase_button
	)

	var current_level: int = (
		ResearchManager.get_upgrade_level(
			upgrade_id
		)
	)

	var maximum_level: int = (
		ResearchManager.get_upgrade_maximum_level()
	)

	var current_bonus: float = (
		ResearchManager.get_search_monetization_bonus_percent()
	)

	search_monetization_level_label.text = (
		"Level %d" % current_level
	)

	search_monetization_max_label.text = (
		"Level %d" % maximum_level
	)

	search_monetization_current_effect_label.text = (
		"Current Effect: +%d%% revenue per page"
		% roundi(current_bonus)
	)

	if ResearchManager.is_upgrade_maxed(
		upgrade_id
	):
		search_monetization_cost_label.text = "—"

		search_monetization_next_effect_label.text = (
			"Next Effect: MAXIMUM LEVEL"
		)

		return
		
	if not ResearchManager.is_next_upgrade_level_unlocked(
		upgrade_id
	):
		search_monetization_cost_label.text = "—"

		search_monetization_next_effect_label.text = (
			"Next Effect: Tier 2 Required"
		)

		return

	var upgrade_cost: float = (
		ResearchManager.get_upgrade_cost(
			upgrade_id
		)
	)

	var next_bonus: float = (
		float(current_level + 1)
		* ResearchManager.REVENUE_BONUS_PERCENT_PER_LEVEL
	)

	search_monetization_cost_label.text = (
		format_research_cost(
			upgrade_cost
		)
	)

	search_monetization_next_effect_label.text = (
		"Next Effect: +%d%% revenue per page"
		% roundi(next_bonus)
	)
	
func refresh_audience_discovery() -> void:
	var upgrade_id: StringName = (
		ResearchManager.UPGRADE_AUDIENCE_DISCOVERY
	)
	
	refresh_research_purchase_button(
		upgrade_id,
		audience_discovery_purchase_button
	)

	var current_level: int = (
		ResearchManager.get_upgrade_level(
			upgrade_id
		)
	)

	var maximum_level: int = (
		ResearchManager.get_upgrade_maximum_level()
	)

	var current_bonus: float = (
		ResearchManager.get_audience_discovery_bonus_percent()
	)

	audience_discovery_level_label.text = (
		"Level %d" % current_level
	)

	audience_discovery_max_label.text = (
		"Level %d" % maximum_level
	)

	audience_discovery_current_effect_label.text = (
		"Current Effect: +%d%% active-user growth"
		% roundi(current_bonus)
	)

	if ResearchManager.is_upgrade_maxed(
		upgrade_id
	):
		audience_discovery_cost_label.text = "—"

		audience_discovery_next_effect_label.text = (
			"Next Effect: MAXIMUM LEVEL"
		)

		return
		
	if not ResearchManager.is_next_upgrade_level_unlocked(
		upgrade_id
	):
		audience_discovery_cost_label.text = "—"

		audience_discovery_next_effect_label.text = (
			"Next Effect: Tier 2 Required"
		)

		return

	var upgrade_cost: float = (
		ResearchManager.get_upgrade_cost(
			upgrade_id
		)
	)

	var next_bonus: float = (
		float(current_level + 1)
		* ResearchManager.ACTIVE_USER_BONUS_PERCENT_PER_LEVEL
	)

	audience_discovery_cost_label.text = (
		format_research_cost(
			upgrade_cost
		)
	)

	audience_discovery_next_effect_label.text = (
		"Next Effect: +%d%% active-user growth"
		% roundi(next_bonus)
	)


# -------------------------------------------------------------------
# Research Point updates
# -------------------------------------------------------------------

func _on_research_points_changed(
	new_points: float
) -> void:
	research_points_value_label.text = (
		format_research_points(
			new_points
		)
	)

	refresh_research_upgrades()


func format_research_points(
	value: float
) -> String:
	var safe_value: float = maxf(
		value,
		0.0
	)

	if is_equal_approx(
		safe_value,
		float(roundi(safe_value))
	):
		return "%d RP" % roundi(
			safe_value
		)

	return "%.1f RP" % safe_value
	
func format_research_cost(
	value: float
) -> String:
	return "%d RP" % roundi(
		maxf(
			value,
			0.0
		)
	)
