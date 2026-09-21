class_name UpgradeCard
extends PanelContainer


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal upgrade_requested(
	upgrade_id: StringName
)


# -------------------------------------------------------------------
# Upgrade Identity
# -------------------------------------------------------------------

@export var upgrade_id: StringName = &""


# -------------------------------------------------------------------
# Node References
# -------------------------------------------------------------------

@onready var title_label: Label = (
	$CardMargin/CardLayout/HeaderRow/TitleLabel
)

@onready var level_label: Label = (
	$CardMargin/CardLayout/HeaderRow/LevelLabel
)

@onready var description_label: Label = (
	$CardMargin/CardLayout/DescriptionLabel
)

@onready var current_effects_label: Label = (
	$CardMargin/CardLayout/ComparisonRow
	/CurrentPanel/CurrentEffectsMargin
	/CurrentEffectsLayout/CurrentEffectsLabel
)

@onready var next_header_label: Label = (
	$CardMargin/CardLayout/ComparisonRow
	/NextPanel/NextEffectsMargin
	/NextEffectsLayout/NextHeaderLabel
)

@onready var next_effects_label: Label = (
	$CardMargin/CardLayout/ComparisonRow
	/NextPanel/NextEffectsMargin
	/NextEffectsLayout/NextEffectsLabel
)

@onready var requirement_header_label: Label = (
	$CardMargin/CardLayout/RequirementPanel
	/RequirementMargin/RequirementLayout
	/RequirementHeaderLabel
)

@onready var requirement_label: Label = (
	$CardMargin/CardLayout/RequirementPanel
	/RequirementMargin/RequirementLayout
	/RequirementLabel
)

@onready var cost_label: Label = (
	$CardMargin/CardLayout/PurchaseRow/CostLabel
)

@onready var upgrade_button: Button = (
	$CardMargin/CardLayout/PurchaseRow/UpgradeButton
)

# -------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	configure_mouse_filters()

	if not upgrade_button.pressed.is_connected(
		_on_upgrade_button_pressed
	):
		upgrade_button.pressed.connect(
			_on_upgrade_button_pressed
		)
		
func configure_mouse_filters() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	set_noninteractive_controls_to_ignore(
		self
	)

	upgrade_button.mouse_filter = (
		Control.MOUSE_FILTER_STOP
	)
	
func set_noninteractive_controls_to_ignore(
	parent_node: Node
) -> void:
	for child: Node in parent_node.get_children():
		if child is Control:
			var child_control: Control = (
				child as Control
			)

			if child_control != upgrade_button:
				child_control.mouse_filter = (
					Control.MOUSE_FILTER_IGNORE
				)

		set_noninteractive_controls_to_ignore(
			child
		)
		


# -------------------------------------------------------------------
# Basic Configuration
# -------------------------------------------------------------------

func configure(
	new_upgrade_id: StringName,
	title: String,
	description: String
) -> void:
	upgrade_id = new_upgrade_id

	title_label.text = title
	description_label.text = description


# -------------------------------------------------------------------
# Display Setters
# -------------------------------------------------------------------

func set_level_text(
	text: String
) -> void:
	level_label.text = text


func set_current_effects(
	text: String
) -> void:
	current_effects_label.text = text


func set_next_upgrade(
	header_text: String,
	effects_text: String
) -> void:
	next_header_label.text = header_text
	next_effects_label.text = effects_text


func set_requirement(
	header_text: String,
	requirement_text: String
) -> void:
	requirement_header_label.text = header_text
	requirement_label.text = requirement_text


func set_cost_text(
	text: String
) -> void:
	cost_label.text = text


func set_upgrade_button(
	text: String,
	disabled: bool,
	tooltip: String = ""
) -> void:
	upgrade_button.text = text
	upgrade_button.disabled = disabled
	upgrade_button.tooltip_text = tooltip
	
# -------------------------------------------------------------------
# Convenience States
# -------------------------------------------------------------------

func set_locked_state(
	level_text: String,
	current_text: String,
	next_header_text: String,
	next_text: String,
	requirement_header_text: String,
	requirement_text: String,
	cost_text: String = "ACCOMPLISHMENT UNLOCK"
) -> void:
	set_level_text(
		level_text
	)

	set_current_effects(
		current_text
	)

	set_next_upgrade(
		next_header_text,
		next_text
	)

	set_requirement(
		requirement_header_text,
		requirement_text
	)

	set_cost_text(
		cost_text
	)

	set_upgrade_button(
		"LOCKED",
		true
	)


func set_maxed_state(
	level_text: String,
	current_text: String,
	status_text: String
) -> void:
	set_level_text(
		level_text
	)

	set_current_effects(
		current_text
	)

	set_next_upgrade(
		"MAXIMUM LEVEL",
		"No additional upgrades are currently available."
	)

	set_requirement(
		"STATUS",
		status_text
	)

	set_cost_text(
		"FULLY UPGRADED"
	)

	set_upgrade_button(
		"MAXIMUM LEVEL",
		true
	)


# -------------------------------------------------------------------
# Button
# -------------------------------------------------------------------

func _on_upgrade_button_pressed() -> void:
	upgrade_requested.emit(
		upgrade_id
	)
