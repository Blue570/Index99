extends PanelContainer


# -------------------------------------------------------------------
# Node References
# -------------------------------------------------------------------

@onready var auto_throttle_card: UpgradeCard = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/AutoThrottleUpgradeCard
)

@onready var scheduler_optimization_card: UpgradeCard = (
	$UpgradesMargin/UpgradesPageLayout/UpgradesScroll
	/UpgradesCatalog/SchedulerOptimizationUpgradeCard
)


# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	configure_upgrade_cards()
	connect_upgrade_card_signals()
	connect_upgrade_signals()

	refresh_upgrades_page()
	
func configure_upgrade_cards() -> void:
	auto_throttle_card.configure(
		&"auto_throttle",
		"AUTO-THROTTLE",
		"Automatically regulates crawler load by pausing "
		+ "and resuming crawl operations."
	)

	scheduler_optimization_card.configure(
		&"scheduler_optimization",
		"SCHEDULER OPTIMIZATION",
		"Improves Scheduler queue capacity, dispatch safety, "
		+ "job prioritization, and autonomous crawling."
	)

func connect_upgrade_card_signals() -> void:
	if not auto_throttle_card.upgrade_requested.is_connected(
		_on_upgrade_card_requested
	):
		auto_throttle_card.upgrade_requested.connect(
			_on_upgrade_card_requested
		)

	if not scheduler_optimization_card.upgrade_requested.is_connected(
		_on_upgrade_card_requested
	):
		scheduler_optimization_card.upgrade_requested.connect(
			_on_upgrade_card_requested
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
		
	if not AutomationManager.scheduler_optimization_level_changed.is_connected(
		_on_scheduler_optimization_level_changed
	):
		AutomationManager.scheduler_optimization_level_changed.connect(
			_on_scheduler_optimization_level_changed
		)

	if not AutomationManager.scheduler_optimization_mastery_count_changed.is_connected(
		_on_scheduler_optimization_mastery_count_changed
	):
		AutomationManager.scheduler_optimization_mastery_count_changed.connect(
			_on_scheduler_optimization_mastery_count_changed
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
	refresh_scheduler_optimization_upgrade()


func refresh_auto_throttle_upgrade() -> void:
	var current_level: int = (
		AutomationManager.get_auto_throttle_level()
	)

	if not AutomationManager.is_auto_throttle_unlocked():
		refresh_locked_auto_throttle()
		return

	auto_throttle_card.set_level_text(
		"LEVEL %d — %s"
		% [
			current_level,
			AutomationManager
				.get_current_auto_throttle_level_name()
		]
	)

	auto_throttle_card.set_current_effects(
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

	auto_throttle_card.set_next_upgrade(
		"NEXT: %s"
		% AutomationManager.get_auto_throttle_level_name(
			next_level
		),
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

	auto_throttle_card.set_locked_state(
		"LOCKED",
		"Auto-Throttle is not yet available.",
		"UNLOCK: PROTOTYPE",
		build_auto_throttle_effect_text(
			AutomationManager.AUTO_THROTTLE_PROTOTYPE_LEVEL
		),
		"ACCOMPLISHMENT",
		"Complete Scheduler-started crawls: %d / %d"
		% [
			completed_crawls,
			required_crawls
		],
		"ACCOMPLISHMENT UNLOCK"
	)

	auto_throttle_card.set_upgrade_button(
		"LOCKED",
		true,
		"Complete %d Scheduler-started crawls to unlock Auto-Throttle."
		% required_crawls
	)


# -------------------------------------------------------------------
# Maximum Level
# -------------------------------------------------------------------

func refresh_maxed_auto_throttle() -> void:
	var current_level: int = (
		AutomationManager.get_auto_throttle_level()
	)

	auto_throttle_card.set_maxed_state(
		"LEVEL %d — %s"
		% [
			current_level,
			AutomationManager
				.get_current_auto_throttle_level_name()
		],
		build_auto_throttle_effect_text(
			current_level
		),
		"Optimized Governor complete."
	)


# -------------------------------------------------------------------
# Requirements
# -------------------------------------------------------------------

func refresh_auto_throttle_requirement(
	next_level: int
) -> void:
	if (
		next_level
		== AutomationManager.AUTO_THROTTLE_MAX_IMPLEMENTED_LEVEL
	):
		var completed_interventions: int = (
			AutomationManager
				.get_successful_auto_throttle_interventions()
		)

		var required_interventions: int = (
			AutomationManager
				.get_auto_throttle_optimized_intervention_requirement()
		)

		var requirement_text: String = (
			"%d / %d successful throttles"
			% [
				completed_interventions,
				required_interventions
			]
		)

		if (
			completed_interventions
			>= required_interventions
		):
			requirement_text = (
				"COMPLETE — %d / %d successful throttles"
				% [
					completed_interventions,
					required_interventions
				]
			)

		auto_throttle_card.set_requirement(
			"MASTERY REQUIREMENT",
			requirement_text
		)

		return

	auto_throttle_card.set_requirement(
		"REQUIREMENT",
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
		auto_throttle_card.set_cost_text(
			"COST: NONE"
		)

	else:
		auto_throttle_card.set_cost_text(
			"COST: "
			+ " + ".join(
				cost_parts
			)
		)

	var can_purchase: bool = (
		AutomationManager
			.can_purchase_auto_throttle_upgrade()
	)

	auto_throttle_card.set_upgrade_button(
		"UPGRADE",
		not can_purchase,
		get_auto_throttle_upgrade_tooltip(
			next_level,
			money_cost,
			research_cost
		)
	)
	
func get_auto_throttle_upgrade_tooltip(
	next_level: int,
	money_cost: float,
	research_cost: float
) -> String:
	if not AutomationManager.is_auto_throttle_upgrade_accomplishment_met(
		next_level
	):
		return (
			"Complete the mastery requirement "
			+ "before purchasing this upgrade."
		)

	if GameState.revenue < money_cost:
		return "Not enough revenue."

	if ResearchManager.research_points < research_cost:
		return "Not enough Research Points."

	return "Purchase this Auto-Throttle upgrade."


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
# Scheduler Optimization
# -------------------------------------------------------------------

func refresh_scheduler_optimization_upgrade() -> void:
	var current_level: int = (
		AutomationManager.get_scheduler_optimization_level()
	)

	scheduler_optimization_card.set_level_text(
		"LEVEL %d — %s"
		% [
			current_level,
			AutomationManager
				.get_current_scheduler_optimization_level_name()
		]
	)

	scheduler_optimization_card.set_current_effects(
		build_scheduler_optimization_effect_text(
			current_level
		)
	)

	if AutomationManager.is_scheduler_optimization_maxed():
		refresh_maxed_scheduler_optimization()
		return

	var next_level: int = (
		AutomationManager.get_next_scheduler_optimization_level()
	)

	scheduler_optimization_card.set_next_upgrade(
		"NEXT: %s"
		% AutomationManager
			.get_scheduler_optimization_level_name(
				next_level
			),
		build_scheduler_optimization_effect_text(
			next_level
		)
	)

	refresh_scheduler_optimization_requirement(
		next_level
	)

	refresh_scheduler_optimization_upgrade_button(
		next_level
	)
	
func build_scheduler_optimization_effect_text(
	level: int
) -> String:
	var queue_capacity: int = (
		AutomationManager.get_scheduler_queue_capacity_for_level(
			level
		)
	)

	var dispatch_text: String = "Basic"
	var priority_text: String = "FIFO"
	var autonomous_text: String = "Locked"

	if (
		level
		>= AutomationManager.SCHEDULER_DISPATCH_CONTROLLER_LEVEL
	):
		dispatch_text = "Load-Aware"

	if (
		level
		>= AutomationManager.SCHEDULER_PRIORITY_LEVEL
	):
		priority_text = (
			"FIFO / Shortest First / Largest First"
		)

	if (
		level
		>= AutomationManager.SCHEDULER_AUTONOMOUS_LEVEL
	):
		autonomous_text = "Unlocked"

	return (
		"Queue Capacity: %d\n"
		% queue_capacity
		+ "Dispatch Control: %s\n"
		% dispatch_text
		+ "Priority Modes: %s\n"
		% priority_text
		+ "Autonomous Scheduling: %s"
		% autonomous_text
	)
	
func refresh_scheduler_optimization_requirement(
	next_level: int
) -> void:
	if (
		next_level
		== AutomationManager.SCHEDULER_QUEUE_EXPANSION_LEVEL
	):
		var completed_crawls: int = (
			AutomationManager.get_scheduled_crawls_completed()
		)

		var required_crawls: int = (
			AutomationManager
				.get_scheduler_queue_expansion_requirement()
		)

		scheduler_optimization_card.set_requirement(
			"ACCOMPLISHMENT",
			"Complete Scheduler-started crawls: %d / %d"
			% [
				completed_crawls,
				required_crawls
			]
		)

		return

	if (
		next_level
		== AutomationManager.SCHEDULER_AUTONOMOUS_LEVEL
	):
		var completed_mastery_crawls: int = (
			AutomationManager
				.get_scheduler_mastery_crawls_completed()
		)

		var required_mastery_crawls: int = (
			AutomationManager
				.get_scheduler_autonomous_requirement()
		)

		var requirement_text: String = (
			"%d / %d scheduled crawls completed"
			% [
				completed_mastery_crawls,
				required_mastery_crawls
			]
		)

		if (
			completed_mastery_crawls
			>= required_mastery_crawls
		):
			requirement_text = (
				"COMPLETE — %d / %d scheduled crawls"
				% [
					completed_mastery_crawls,
					required_mastery_crawls
				]
			)

		scheduler_optimization_card.set_requirement(
			"MASTERY REQUIREMENT",
			requirement_text
		)

		return

	scheduler_optimization_card.set_requirement(
		"REQUIREMENT",
		"READY — No additional accomplishment required."
	)
	
func refresh_scheduler_optimization_upgrade_button(
	next_level: int
) -> void:
	if (
		next_level
		== AutomationManager.SCHEDULER_QUEUE_EXPANSION_LEVEL
	):
		scheduler_optimization_card.set_cost_text(
			"ACCOMPLISHMENT UNLOCK"
		)

		scheduler_optimization_card.set_upgrade_button(
			"LOCKED",
			true,
			"Complete the required Scheduler-started crawls "
			+ "to earn Queue Expansion."
		)

		return

	var money_cost: float = (
		AutomationManager
			.get_scheduler_optimization_money_cost_for_level(
				next_level
			)
	)

	var research_cost: float = (
		AutomationManager
			.get_scheduler_optimization_research_cost_for_level(
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
		scheduler_optimization_card.set_cost_text(
			"COST: NONE"
		)

	else:
		scheduler_optimization_card.set_cost_text(
			"COST: "
			+ " + ".join(
				cost_parts
			)
		)

	var can_purchase: bool = (
		AutomationManager
			.can_purchase_scheduler_optimization_upgrade()
	)

	scheduler_optimization_card.set_upgrade_button(
		"UPGRADE",
		not can_purchase,
		get_scheduler_optimization_upgrade_tooltip(
			next_level,
			money_cost,
			research_cost
		)
	)
	
func get_scheduler_optimization_upgrade_tooltip(
	next_level: int,
	money_cost: float,
	research_cost: float
) -> String:
	if not AutomationManager.is_scheduler_optimization_accomplishment_met(
		next_level
	):
		return (
			"Complete the required accomplishment "
			+ "before purchasing this upgrade."
		)

	if GameState.revenue < money_cost:
		return "Not enough revenue."

	if ResearchManager.research_points < research_cost:
		return "Not enough Research Points."

	return "Purchase this Scheduler Optimization upgrade."
	
func refresh_maxed_scheduler_optimization() -> void:
	var current_level: int = (
		AutomationManager.get_scheduler_optimization_level()
	)

	scheduler_optimization_card.set_maxed_state(
		"LEVEL %d — %s"
		% [
			current_level,
			AutomationManager
				.get_current_scheduler_optimization_level_name()
		],
		build_scheduler_optimization_effect_text(
			current_level
		),
		"Autonomous Scheduler complete."
	)


# -------------------------------------------------------------------
# Button Callback
# -------------------------------------------------------------------

func _on_upgrade_card_requested(
	upgrade_id: StringName
) -> void:
	match upgrade_id:
		&"auto_throttle":
			var previous_level: int = (
				AutomationManager.get_auto_throttle_level()
			)

			AutomationManager.purchase_auto_throttle_upgrade()

			var new_level: int = (
				AutomationManager.get_auto_throttle_level()
			)

			if new_level > previous_level:
				BuildManager.add_build_progress(
					1
				)

		&"scheduler_optimization":
			var previous_level: int = (
				AutomationManager
					.get_scheduler_optimization_level()
			)

			AutomationManager.purchase_scheduler_optimization_upgrade()

			var new_level: int = (
				AutomationManager
					.get_scheduler_optimization_level()
			)

			if new_level > previous_level:
				BuildManager.add_build_progress(
					1
				)

		_:
			return

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
	
func _on_scheduler_optimization_level_changed(
	_new_level: int
) -> void:
	refresh_upgrades_page()


func _on_scheduler_optimization_mastery_count_changed(
	_new_count: int
) -> void:
	refresh_upgrades_page()
