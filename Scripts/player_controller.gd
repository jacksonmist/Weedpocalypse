extends Node2D

@onready var tool_manager: Node = $ToolManager
@onready var mouse_controller: Area2D = $MouseController
@onready var ui_manager: UIManager = %UIManager


var is_mouse_active

func _ready() -> void:
	tool_manager.set_mouse_controller(mouse_controller)
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("Hand")):
		tool_manager.switch_tool(Game_Enums.Tool.HAND, true)
	if(event.is_action_pressed("Scythe")):
		tool_manager.switch_tool(Game_Enums.Tool.SCYTHE, true)
	if(event is InputEventMouseButton):
		tool_manager.set_tool_active(event.pressed)
		mouse_controller.set_active(event.pressed)
