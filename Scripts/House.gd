extends Node3D


func _process(_delta: float):
	
	if Global.inHouse == 1:
		hide()
	else:
		show()
