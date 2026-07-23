extends CharacterBody3D


@export_category("Movement")
@export var speed: float = 4.0
@export var sprint_speed_modifier: float = 2.0
@export var jump_velocity: float = 4.5

@export_category("Animation")
@export var player_anim_player: AnimationPlayer
@export var idle_animation_speed: float = 1.0
@export var running_animation_speed: float = 1.0
@export var jumping_animation_speed: float = 1.5

@onready var player_model: Node3D = %PlayerModel


func _ready() -> void:
	if player_anim_player == null:
		push_error("Player AnimationPlayer has not been assigned.")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal_movement()

	# Keep the character locked to the side-scrolling plane.
	velocity.z = 0.0

	move_and_slide()

	_update_animation()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func _handle_jump() -> void:
	if (
		Input.is_action_just_pressed("up")
		and Global.inHouse == 0
		and is_on_floor()
	):
		velocity.y = jump_velocity


func _handle_horizontal_movement() -> void:
	var direction := Input.get_axis("left", "right")
	var current_speed := speed

	if Input.is_action_pressed("sprint") and is_on_floor():
		current_speed *= sprint_speed_modifier

	velocity.x = direction * current_speed

	if direction < 0.0:
		_face_left()
	elif direction > 0.0:
		_face_right()


func _update_animation() -> void:
	if not is_on_floor():
		_play_animation(
			"jump/jump",
			jumping_animation_speed
		)
	elif absf(velocity.x) > 0.01:
		_play_animation(
			"running/running",
			running_animation_speed
		)
	else:
		_play_animation(
			"idle/idle",
			idle_animation_speed
		)


func _play_animation(
	animation_name: StringName,
	playback_speed: float = 1.0
) -> void:
	if player_anim_player == null:
		return

	if not player_anim_player.has_animation(animation_name):
		push_warning(
			"Animation does not exist: %s" % animation_name
		)
		return

	if player_anim_player.current_animation != animation_name:
		player_anim_player.play(
			animation_name,
			-1.0,
			playback_speed
		)


func _face_left() -> void:
	player_model.scale.z = -absf(player_model.scale.z)


func _face_right() -> void:
	player_model.scale.z = absf(player_model.scale.z)
