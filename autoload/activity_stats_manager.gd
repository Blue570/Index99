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
# Save / Load
# -------------------------------------------------------------------

func get_completions_by_type_for_save() -> Dictionary:
	var save_data: Dictionary = {}

	for activity_type: Variant in completions_by_type.keys():
		save_data[
			str(activity_type)
		] = int(
			completions_by_type[
				activity_type
			]
		)

	return save_data


func restore_saved_state(
	saved_total: int,
	saved_completions_by_type: Dictionary
) -> void:
	total_activities_completed = max(
		saved_total,
		0
	)

	completions_by_type.clear()

	for raw_activity_type: Variant in saved_completions_by_type.keys():
		var activity_type: StringName = StringName(
			str(raw_activity_type)
		)

		if activity_type == &"":
			continue

		var raw_count: Variant = (
			saved_completions_by_type[
				raw_activity_type
			]
		)

		if (
			typeof(raw_count) != TYPE_INT
			and typeof(raw_count) != TYPE_FLOAT
		):
			continue

		var safe_count: int = max(
			int(raw_count),
			0
		)

		if safe_count <= 0:
			continue

		completions_by_type[
			activity_type
		] = safe_count

	activity_stats_reset.emit()


# -------------------------------------------------------------------
# Reset
# -------------------------------------------------------------------

func reset_activity_stats() -> void:
	total_activities_completed = 0

	completions_by_type.clear()

	activity_stats_reset.emit()
