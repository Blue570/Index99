extends PanelContainer


# -------------------------------------------------------------------
# Node References
# -------------------------------------------------------------------

@onready var auto_throttle_level_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleHeaderRow/AutoThrottleLevelLabel
)

@onready var auto_throttle_current_effects_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleComparisonRow/AutoThrottleCurrentPanel
	/CurrentEffectsMargin/CurrentEffectsLayout
	/AutoThrottleCurrentEffectsLabel
)

@onready var auto_throttle_next_header_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleComparisonRow/AutoThrottleNextPanel
	/NextEffectsMargin/NextEffectsLayout
	/AutoThrottleNextHeaderLabel
)

@onready var auto_throttle_next_effects_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleComparisonRow/AutoThrottleNextPanel
	/NextEffectsMargin/NextEffectsLayout
	/AutoThrottleNextEffectsLabel
)
@onready var auto_throttle_requirement_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleRequirementPanel
	/RequirementMargin/RequirementLayout
	/AutoThrottleRequirementLabel
)

@onready var auto_throttle_upgrade_button: Button = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleUpgradeButton
)

@onready var requirement_header_label: Label = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradePanel
	/AutoThrottleUpgradeMargin/AutoThrottleUpgradeLayout
	/AutoThrottleRequirementPanel
	/RequirementMargin/RequirementLayout
	/RequirementHeaderLabel
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_buttons()
	connect_upgrade_signals()
	refresh_upgrades_page()


func connect_buttons() -> void:
	if not auto_throttle_upgrade_button.pressed.is_connected(
		_on_auto_throttle_upgrade_button_pressed
	):
		auto_throttle_upgrade_button.pressed.connect(
			_on_auto_throttle_upgrade_button_pressed
		)


func connect_upgrade_signals() -> void:
	if not AutomationManager.auto_throttle_unlock_changed.is_connected(
		_on_auto_throttle_unlock_changed
	):
		AutomationManager.auto_throttle_unlock_changed.connect(
			_on_auto_throttle_unlock_changed
		)

	if not AutomationManager.auto_throttle_level_changed.is_connected(
		_on_auto_throttle_level_changed
	):
		AutomationManager.auto_throttle_level_changed.connect(
			_on_auto_throttle_level_changed
		)

	if not AutomationManager.auto_throttle_intervention_count_changed.is_connected(
		_on_auto_throttle_intervention_count_changed
	):
		AutomationManager.auto_throttle_intervention_count_changed.connect(
			_on_auto_throttle_intervention_count_changed
		)

	if not AutomationManager.scheduled_crawl_completed_count_changed.is_connected(
		_on_scheduled_crawl_completed_count_changed
	):
		AutomationManager.scheduled_crawl_completed_count_changed.connect(
			_on_scheduled_crawl_completed_count_changed
		)

	if not GameState.revenue_changed.is_connected(
		_on_revenue_changed
	):
		GameState.revenue_changed.connect(
			_on_revenue_changed
		)

	if not ResearchManager.research_points_changed.is_connected(
		_on_research_points_changed
	):
		ResearchManager.research_points_changed.connect(
			_on_research_points_changed
		)


# -------------------------------------------------------------------
# Main Refresh
# -------------------------------------------------------------------

func refresh_upgrades_page() -> void:
	refresh_auto_throttle_upgrade()


func refresh_auto_throttle_upgrade() -> void:
	var current_level: int = (
		AutomationManager.get_auto_throttle_level()
	)

	if not AutomationManager.is_auto_throttle_unlocked():
		refresh_locked_auto_throttle()
		return

	auto_throttle_level_label.text = (
		"LEVEL %d — %s"
		% [
			current_level,
			AutomationManager
				.get_current_auto_throttle_level_name()
		]
	)

	auto_throttle_current_effects_label.text = (
		build_auto_throttle_effect_text(
			current_level
	)
)

	if AutomationManager.is_auto_throttle_maxed():
		refresh_maxed_auto_throttle()
		return

	var next_level: int = (
		AutomationManager.get_next_auto_throttle_level()
	)

	auto_throttle_next_header_label.text = (
		"NEXT: %s"
		% AutomationManager.get_auto_throttle_level_name(
			next_level
	)
)

	auto_throttle_next_effects_label.text = (
		build_auto_throttle_effect_text(
			next_level
	)
)

	refresh_auto_throttle_requirement(
		next_level
	)

	refresh_auto_throttle_upgrade_button(
		next_level
	)


# -------------------------------------------------------------------
# Locked State
# -------------------------------------------------------------------

func refresh_locked_auto_throttle() -> void:
	var completed_crawls: int = (
		AutomationManager.get_scheduled_crawls_completed()
	)

	var required_crawls: int = (
		AutomationManager.get_auto_throttle_unlock_requirement()
	)
	
	requirement_header_label.text = (
		"ACCOMPLISHMENT"
	)

	auto_throttle_level_label.text = (
		"LOCKED"
	)

	auto_throttle_current_effects_label.text = (
		"Auto-Throttle is not yet available."
)

	auto_throttle_next_effects_label.text = (
		"UNLOCK: PROTOTYPE\n"
		+ build_auto_throttle_effect_text(
			AutomationManager.AUTO_THROTTLE_PROTOTYPE_LEVEL
		)
	)

	auto_throttle_requirement_label.text = (
		"Complete Scheduler-started crawls: %d / %d"
	% [
		completed_crawls,
		required_crawls
	]
)

	auto_throttle_upgrade_button.text = (
		"LOCKED"
	)

	auto_throttle_upgrade_button.disabled = true


# -------------------------------------------------------------------
# Maximum Level
# -------------------------------------------------------------------

func refresh_maxed_auto_throttle() -> void:
	auto_throttle_next_effects_label.text = (
		"NEXT UPGRADE\n"
		+ "Maximum currently implemented level reached."
	)

	auto_throttle_requirement_label.text = (
		"STATUS\n"
		+ "Optimized Governor complete."
	)

	auto_throttle_upgrade_button.text = (
		"MAXIMUM LEVEL"
	)

	auto_throttle_upgrade_button.disabled = true


# -------------------------------------------------------------------
# Requirements
# -------------------------------------------------------------------

func refresh_auto_throttle_requirement(
	next_level: int
) -> void:
	if next_level == 4:
		requirement_header_label.text = (
			"MASTERY REQUIREMENT"
		)

		var completed_interventions: int = (
			AutomationManager
				.get_successful_auto_throttle_interventions()
		)

		var required_interventions: int = (
			AutomationManager
				.get_auto_throttle_optimized_intervention_requirement()
		)

		if (
			completed_interventions
			>= required_interventions
		):
			auto_throttle_requirement_label.text = (
				"COMPLETE — %d / %d successful throttles"
				% [
					completed_interventions,
					required_interventions
				]
			)

		else:
			auto_throttle_requirement_label.text = (
				"%d / %d successful throttles"
				% [
					completed_interventions,
					required_interventions
				]
			)

		return

	requirement_header_label.text = (
		"REQUIREMENT"
	)

	auto_throttle_requirement_label.text = (
		"READY — No additional accomplishment required."
	)


# -------------------------------------------------------------------
# Upgrade Button
# -------------------------------------------------------------------

func refresh_auto_throttle_upgrade_button(
	next_level: int
) -> void:
	var money_cost: float = (
		AutomationManager
			.get_auto_throttle_money_cost_for_level(
				next_level
			)
	)

	var research_cost: float = (
		AutomationManager
			.get_auto_throttle_research_cost_for_level(
				next_level
			)
	)

	var cost_parts: PackedStringArray = []

	if money_cost > 0.0:
		cost_parts.append(
			"$%.0f" % money_cost
		)

	if research_cost > 0.0:
		cost_parts.append(
			"%.0f RP" % research_cost
		)

	if cost_parts.is_empty():
		auto_throttle_upgrade_button.text = (
			"UPGRADE"
		)
	else:
		auto_throttle_upgrade_button.text = (
			"UPGRADE — "
			+ " + ".join(cost_parts)
		)

	auto_throttle_upgrade_button.disabled = (
		not AutomationManager
			.can_purchase_auto_throttle_upgrade()
	)

	update_auto_throttle_upgrade_tooltip(
		next_level,
		money_cost,
		research_cost
	)


func update_auto_throttle_upgrade_tooltip(
	next_level: int,
	money_cost: float,
	research_cost: float
) -> void:
	if not AutomationManager.is_auto_throttle_upgrade_accomplishment_met(
		next_level
	):
		auto_throttle_upgrade_button.tooltip_text = (
			"Complete the mastery requirement "
			+ "before purchasing this upgrade."
		)

		return

	if GameState.revenue < money_cost:
		auto_throttle_upgrade_button.tooltip_text = (
			"Not enough revenue."
		)

		return

	if ResearchManager.research_points < research_cost:
		auto_throttle_upgrade_button.tooltip_text = (
			"Not enough Research Points."
		)

		return

	auto_throttle_upgrade_button.tooltip_text = (
		"Purchase this Auto-Throttle upgrade."
	)


# -------------------------------------------------------------------
# Effect Display
# -------------------------------------------------------------------

func build_auto_throttle_effect_text(
	level: int
) -> String:
	var maximum_cycles: int = (
		AutomationManager
			.get_auto_throttle_max_cycles_for_level(
				level
			)
	)

	var cycle_text: String = ""

	if maximum_cycles < 0:
		cycle_text = "Unlimited"
	else:
		cycle_text = str(
			maximum_cycles
		)

	return (
		"Throttle Cycles per Crawl: %s\n"
		% cycle_text
		+ "Trigger Load: %.0f%%\n"
		% AutomationManager
			.get_auto_throttle_trigger_percent_for_level(
				level
			)
		+ "Resume Load: %.0f%%\n"
		% AutomationManager
			.get_auto_throttle_resume_percent_for_level(
				level
			)
		+ "Reaction Delay: %.1f sec\n"
		% AutomationManager
			.get_auto_throttle_reaction_delay_for_level(
				level
			)
		+ "Cooldown: %.0f sec"
		% AutomationManager
			.get_auto_throttle_cooldown_for_level(
				level
			)
	)


# -------------------------------------------------------------------
# Button Callback
# -------------------------------------------------------------------

func _on_auto_throttle_upgrade_button_pressed() -> void:
	AutomationManager.purchase_auto_throttle_upgrade()

	refresh_upgrades_page()


# -------------------------------------------------------------------
# Signal Callbacks
# -------------------------------------------------------------------

func _on_auto_throttle_unlock_changed(
	_is_unlocked: bool
) -> void:
	refresh_upgrades_page()


func _on_auto_throttle_level_changed(
	_new_level: int
) -> void:
	refresh_upgrades_page()


func _on_auto_throttle_intervention_count_changed(
	_new_count: int
) -> void:
	refresh_upgrades_page()


func _on_scheduled_crawl_completed_count_changed(
	_new_count: int
) -> void:
	refresh_upgrades_page()


func _on_revenue_changed(
	_new_revenue: float
) -> void:
	refresh_upgrades_page()


func _on_research_points_changed(
	_new_points: float
) -> void:
	refresh_upgrades_page()
