extends Node


# -------------------------------------------------------------------
# Signals
# -------------------------------------------------------------------

signal activity_completed(
	activity_type: StringName,
	type_total: int,
	overall_total: int
)

signal activity_stats_reset


# -------------------------------------------------------------------
# Activity Statistics
# -------------------------------------------------------------------

var total_activities_completed: int = 0

var completions_by_type: Dictionary = {}


# -------------------------------------------------------------------
# Completion Tracking
# -------------------------------------------------------------------

func record_completion(
	activity_type: StringName
) -> void:
	if activity_type == &"":
		push_warning(
			"ActivityStatsManager: "
			+ "Cannot record an empty activity type."
		)

		return

	var current_type_total: int = (
		get_type_completed(
			activity_type
		)
	)

	current_type_total += 1

	completions_by_type[
		activity_type
	] = current_type_total

	total_activities_completed += 1

	activity_completed.emit(
		activity_type,
		current_type_total,
		total_activities_completed
	)


# -------------------------------------------------------------------
# Statistics Getters
# -------------------------------------------------------------------

func get_total_completed() -> int:
	return total_activities_completed


func get_type_completed(
	activity_type: StringName
) -> int:
	if not completions_by_type.has(
		activity_type
	):
		return 0

	return int(
		completions_by_type[
			activity_type
		]
	)


func get_unique_types_completed() -> int:
	return completions_by_type.size()


func has_completed_type(
	activity_type: StringName
) -> bool:
	return (
		get_type_completed(activity_type)
		> 0
	)


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_activity_stats() -> void:
	total_activities_completed = 0

	completions_by_type.clear()

	activity_stats_reset.emit()
