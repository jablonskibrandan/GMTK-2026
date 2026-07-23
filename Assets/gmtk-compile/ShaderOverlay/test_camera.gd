extends Node3D

@export var distance: float = 5.0
@export var speed: float = 1.0

var start_position: Vector3

func _ready():
	start_position = position

func _process(delta):
	position.x = start_position.x + sin(Time.get_ticks_msec() / 1000.0 * speed) * distance
