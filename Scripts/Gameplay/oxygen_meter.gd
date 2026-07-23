class_name OxygenMeter
extends Node


signal oxygen_changed(
	current_oxygen: float,
	maximum_oxygen: float
)

signal oxygen_depleted


@export_category("Oxygen")

@export_range(1.0, 1000.0, 1.0, "or_greater")
var maximum_oxygen: float = 100.0

## Oxygen points lost per second.
@export_range(0.0, 100.0, 0.1, "or_greater")
var drain_per_second: float = 2.0

## Multiplies the normal oxygen drain.
## 0.5 means half drain, 1.0 means normal drain.
@export_range(0.0, 10.0, 0.05, "or_greater")
var oxygen_drain_multiplier: float = 1.0

## Whether oxygen should begin draining when the scene starts.
@export var draining_enabled: bool = true


var current_oxygen: float
var oxygen_has_depleted: bool = false


func _ready() -> void:
	current_oxygen = maximum_oxygen
	oxygen_has_depleted = false

	_emit_oxygen_changed()


func _process(delta: float) -> void:
	if not draining_enabled:
		return

	if oxygen_has_depleted:
		return

	var oxygen_to_drain := (
		drain_per_second
		* oxygen_drain_multiplier
		* delta
	)

	drain_oxygen(oxygen_to_drain)


func drain_oxygen(amount: float) -> void:
	if amount <= 0.0:
		return

	if oxygen_has_depleted:
		return

	current_oxygen = clampf(
		current_oxygen - amount,
		0.0,
		maximum_oxygen
	)

	_emit_oxygen_changed()

	if is_zero_approx(current_oxygen):
		_deplete_oxygen()


func refill_oxygen(amount: float) -> void:
	if amount <= 0.0:
		return

	current_oxygen = clampf(
		current_oxygen + amount,
		0.0,
		maximum_oxygen
	)

	if current_oxygen > 0.0:
		oxygen_has_depleted = false

	_emit_oxygen_changed()


func refill_completely() -> void:
	current_oxygen = maximum_oxygen
	oxygen_has_depleted = false

	_emit_oxygen_changed()


func set_oxygen(new_oxygen: float) -> void:
	current_oxygen = clampf(
		new_oxygen,
		0.0,
		maximum_oxygen
	)

	oxygen_has_depleted = is_zero_approx(
		current_oxygen
	)

	_emit_oxygen_changed()

	if oxygen_has_depleted:
		oxygen_depleted.emit()


func reset_oxygen() -> void:
	current_oxygen = maximum_oxygen
	oxygen_has_depleted = false
	draining_enabled = true
	oxygen_drain_multiplier = 1.0

	_emit_oxygen_changed()


func start_draining() -> void:
	draining_enabled = true


func stop_draining() -> void:
	draining_enabled = false


func set_drain_multiplier(multiplier: float) -> void:
	oxygen_drain_multiplier = maxf(
		multiplier,
		0.0
	)


func get_oxygen_ratio() -> float:
	if maximum_oxygen <= 0.0:
		return 0.0

	return clampf(
		current_oxygen / maximum_oxygen,
		0.0,
		1.0
	)


func is_depleted() -> bool:
	return oxygen_has_depleted


func _deplete_oxygen() -> void:
	if oxygen_has_depleted:
		return

	current_oxygen = 0.0
	oxygen_has_depleted = true
	draining_enabled = false

	_emit_oxygen_changed()
	oxygen_depleted.emit()


func _emit_oxygen_changed() -> void:
	oxygen_changed.emit(
		current_oxygen,
		maximum_oxygen
	)
