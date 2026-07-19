extends MeshInstance3D

var mat = StandardMaterial3D

@onready var player := $"../../CharacterBody3D"
@onready var textLabel := $"../../CanvasLayer/Label"

func _ready():
	mat = get_active_material(0)

			
func _process(_delta: float):
	
	if global_position.distance_squared_to(player.global_position) < 2:
		textLabel.text = "press 'W' to use door"
		textLabel.show()
		Global.touchingDoor = 1
		
		if Input.is_action_just_pressed("W"):
			if Global.inHouse == 0:
				Global.inHouse = 1
				player.position.z = -2
			else:
				Global.inHouse = 0
				player.position.z = 0
	else:
		textLabel.hide()
		Global.touchingDoor = 0
		
	if Global.inHouse == 1:
		mat.albedo_color.a = 0.5
	else:
		mat.albedo_color.a = 1.0
