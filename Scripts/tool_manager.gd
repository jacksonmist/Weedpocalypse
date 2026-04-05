class_name ToolManager extends Node

signal new_tool(tool: Game_Enums.Tool)
@onready var ui: UIManager = %UIManager
var mouse_controller: MouseController
var current_tool: Resource
var hand_tool: Tool = HandTool.new()
var scythe_tool: Tool = ScytheTool.new()
var weedkiller_tool: Tool = WeedkillerTool.new()

func _ready() -> void:
	ui.set_tool_manager(self)
	current_tool = hand_tool
	
func switch_tool(tool_type: Game_Enums.Tool):
	if(tool_type == current_tool.type):
		return
	new_tool.emit(tool_type)
	match tool_type:
		Game_Enums.Tool.HAND:
			current_tool = hand_tool
			mouse_controller.set_tool(Game_Enums.Tool.HAND)
		Game_Enums.Tool.SCYTHE:
			current_tool = scythe_tool
			mouse_controller.set_tool(Game_Enums.Tool.SCYTHE)
		Game_Enums.Tool.WEEDKILLER:
			current_tool = weedkiller_tool
			mouse_controller.set_tool(Game_Enums.Tool.WEEDKILLER)
	print(current_tool.name)
	
func set_tool_active(state: bool):
	if(current_tool):
		current_tool.set_active(state)

func set_mouse_controller(ref: MouseController):
	mouse_controller = ref
