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
# Setup
# -------------------------------------------------------------------

func _ready() -> void:
	connect_research_signals()

	refresh_research_points()


func connect_research_signals() -> void:
	if not ResearchManager.research_points_changed.is_connected(
		_on_research_points_changed
	):
		ResearchManager.research_points_changed.connect(
			_on_research_points_changed
		)


func refresh_research_points() -> void:
	_on_research_points_changed(
		ResearchManager.research_points
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
