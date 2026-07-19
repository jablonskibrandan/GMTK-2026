extends CharacterBody3D


var SPEED = 0.1
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Global.touchingDoor == 0 and Global.inHouse == 0:
		if Input.is_action_just_pressed("W") and is_on_floor():
			velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("A"):
		position.x -= SPEED
	if Input.is_action_pressed("D"):
		position.x += SPEED

	move_and_slide()
