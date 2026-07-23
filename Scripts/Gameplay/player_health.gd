class_name PlayerHealth
extends Node


signal health_changed(current_health: float, maximum_health: float)
signal health_depleted


@export_category("Health")

@export_range(1.0, 1000.0, 1.0, "or_greater")
var maximum_health: float = 100.0

var current_health: float


func _ready() -> void:
	current_health = maximum_health

	health_changed.emit(
		current_health,
		maximum_health
	)
		


func hit(damage: float) -> void:
	if damage <= 0.0:
		return

	if current_health <= 0.0:
		return

	current_health = clampf(
		current_health - damage,
		0.0,
		maximum_health
	)

	health_changed.emit(
		current_health,
		maximum_health
	)

	if is_zero_approx(current_health):
		health_depleted.emit()


func heal(amount: float) -> void:
	if amount <= 0.0:
		return

	if current_health <= 0.0:
		return

	current_health = clampf(
		current_health + amount,
		0.0,
		maximum_health
	)

	health_changed.emit(
		current_health,
		maximum_health
	)


func reset_health() -> void:
	current_health = maximum_health

	health_changed.emit(
		current_health,
		maximum_health
	)
