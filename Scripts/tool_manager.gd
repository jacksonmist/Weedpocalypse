extends Node

var current_tool: Resource
var hand_tool: Tool = HandTool.new()
var scythe_tool: Tool = ScytheTool.new()
var weedkiller_tool: Tool = WeedkillerTool.new()

func _ready() -> void:
	pass

func switch_tool(tool_type: Game_Enums.Tool):
	match tool_type:
		Game_Enums.Tool.HAND:
			current_tool = hand_tool
		Game_Enums.Tool.SCYTHE:
			current_tool = scythe_tool
		Game_Enums.Tool.WEEDKILLER:
			current_tool = weedkiller_tool
	print(current_tool.name)
	
func set_tool_active(state: bool):
	if(current_tool):
		current_tool.set_active(state)
