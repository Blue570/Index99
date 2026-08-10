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
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_research_signals()

	refresh_research_points()
	refresh_research_upgrades()
	refresh_research_effects()


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

	available_research_panel.set_status(
		"3 AVAILABLE",
		ThemeManager.STATUS_INFORMATION
	)
	
func refresh_crawler_optimization() -> void:
	var upgrade_id: StringName = (
		ResearchManager.UPGRADE_CRAWLER_OPTIMIZATION
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
