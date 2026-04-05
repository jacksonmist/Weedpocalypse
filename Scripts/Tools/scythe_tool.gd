class_name ScytheTool extends Tool
var type: = Game_Enums.Tool.SCYTHE
func _init():
	name = "Scythe"

func set_active(state: bool):
	is_active = state
