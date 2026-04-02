extends Node2D

@onready var tool_manager: Node = $ToolManager
@onready var mouse_controller: Area2D = $MouseController

var is_mouse_active

func _ready() -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("Hand")):
		tool_manager.switch_tool(Game_Enums.Tool.HAND)
		mouse_controller.set_tool(Game_Enums.Tool.HAND)
	if(event.is_action_pressed("Scythe")):
		tool_manager.switch_tool(Game_Enums.Tool.SCYTHE)
		mouse_controller.set_tool(Game_Enums.Tool.SCYTHE)
	if(event.is_action_pressed("Weekiller")):
		tool_manager.switch_tool(Game_Enums.Tool.WEEDKILLER)
		mouse_controller.set_tool(Game_Enums.Tool.WEEDKILLER)
	if(event is InputEventMouseButton):
		tool_manager.set_tool_active(event.pressed)
		mouse_controller.set_active(event.pressed)
