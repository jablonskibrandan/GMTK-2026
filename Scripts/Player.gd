extends CharacterBody3D


var SPEED = 0.1
const JUMP_VELOCITY = 4.5
@onready var playerModel := %PlayerModel

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed("up") and Global.inHouse == 0 and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("left"):
		position.x -= SPEED
		playerModel.scale.z = -1 # inverse model to look back
	if Input.is_action_pressed("right"):
		position.x += SPEED
		playerModel.scale.z = 1

	move_and_slide()
