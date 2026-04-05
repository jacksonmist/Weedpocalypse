class_name WeedkillerTool extends Tool

var type: = Game_Enums.Tool.WEEDKILLER
func _init() -> void:
	name = "Weedkiller"
	
func set_active(state: bool):
	is_active = state
