class_name GameManager
extends Node


signal game_over_started(reason: String)


@export_category("Player Components")
@export var oxygen: OxygenMeter
@export var player_health: PlayerHealth

@export_category("HUD")
@export var hud: HUD

@export_category("Game Over UI")
@export var game_over_screen: Control
@export var game_over_label: Label


var game_over: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	game_over = false

	if game_over_screen != null:
		game_over_screen.visible = false

	_connect_oxygen()
	_connect_health()


func _connect_oxygen() -> void:
	if oxygen == null:
		push_error(
			"GameManager: OxygenMeter has not been assigned."
		)
		return

	if not oxygen.oxygen_changed.is_connected(
		_on_oxygen_changed
	):
		oxygen.oxygen_changed.connect(
			_on_oxygen_changed
		)

	if not oxygen.oxygen_depleted.is_connected(
		_on_oxygen_depleted
	):
		oxygen.oxygen_depleted.connect(
			_on_oxygen_depleted
		)

	# Reset after connecting so the HUD receives the initial value.
	oxygen.reset_oxygen()


func _connect_health() -> void:
	if player_health == null:
		push_error(
			"GameManager: PlayerHealth has not been assigned."
		)
		return

	if not player_health.health_changed.is_connected(
		_on_health_changed
	):
		player_health.health_changed.connect(
			_on_health_changed
		)

	if not player_health.health_depleted.is_connected(
		_on_health_depleted
	):
		player_health.health_depleted.connect(
			_on_health_depleted
		)

	# Reset after connecting so the HUD receives the initial value.
	player_health.reset_health()


func _on_oxygen_changed(
	current_oxygen: float,
	maximum_oxygen: float
) -> void:
	if hud == null:
		return

	hud.update_oxygen(
		current_oxygen,
		maximum_oxygen
	)


func _on_health_changed(
	current_health: float,
	maximum_health: float
) -> void:
	if hud == null:
		return

	hud.update_health(
		current_health,
		maximum_health
	)


func _on_oxygen_depleted() -> void:
	if hud != null:
		hud.show_oxygen_depleted()

	end_game("OXYGEN DEPLETED")


func _on_health_depleted() -> void:
	if hud != null:
		hud.show_health_depleted()

	end_game("HEALTH DEPLETED")


func end_game(reason: String) -> void:
	if game_over:
		return

	game_over = true

	if oxygen != null:
		oxygen.stop_draining()

	game_over_started.emit(reason)

	if game_over_label != null:
		game_over_label.text = reason

	if game_over_screen != null:
		game_over_screen.visible = true

	get_tree().paused = true
