class_name GameManager
extends Node


signal game_over_started(reason: String)


@export_category("Player Components")
@export var oxygen: OxygenMeter
@export var player_health: PlayerHealth

@export_category("Game Over UI")
@export var game_over_screen: Control
@export var game_over_label: Label

var game_over: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	if game_over_screen != null:
		game_over_screen.visible = false

	if oxygen == null:
		push_error("GameManager: OxygenMeter has not been assigned.")
	else:
		oxygen.oxygen_depleted.connect(
			_on_oxygen_depleted
		)

	if player_health == null:
		push_error("GameManager: PlayerHealth has not been assigned.")
	else:
		player_health.health_depleted.connect(
			_on_health_depleted
		)


func _on_oxygen_depleted() -> void:
	end_game("OXYGEN DEPLETED")


func _on_health_depleted() -> void:
	end_game("HEALTH DEPLETED")


func end_game(reason: String) -> void:
	if game_over:
		return

	game_over = true

	game_over_started.emit(reason)

	if game_over_label != null:
		game_over_label.text = reason

	if game_over_screen != null:
		game_over_screen.visible = true

	get_tree().paused = true
