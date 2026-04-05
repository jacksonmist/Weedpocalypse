class_name HandTool extends Tool
var type: = Game_Enums.Tool.HAND
func _init():
	name = "hand"

func set_active(state: bool):
	is_active = state
