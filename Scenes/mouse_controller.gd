extends Area2D

var mouse_position: Vector2
var current_tool: Game_Enums.Tool

var grabbed_weeds: Array[Weed]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_tool = Game_Enums.Tool.HAND
	area_entered.connect(use_tool)
	monitoring = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position()

func set_tool(tool: Game_Enums.Tool):
	current_tool = tool

func set_active(is_active: bool):
	monitoring = is_active
	if(!is_active):
		for weed in grabbed_weeds:
			weed.grab(false)
		grabbed_weeds = []
	
func use_tool(area: Area2D):
	var weed = area.get_parent()
	match current_tool:
		Game_Enums.Tool.HAND:
			if(add_grabbed_weed(weed)):
				weed.grab(true)
		Game_Enums.Tool.SCYTHE:
			weed.cut()
		Game_Enums.Tool.WEEDKILLER:
			weed.weedkiller()

func add_grabbed_weed(weed: Weed):
	if(!grabbed_weeds.has(weed)):
		grabbed_weeds.append(weed)
		#weed.stretched.connect(remove_weed)
		return true
	return false

#func remove_weed(weed: Weed):
	#if(grabbed_weeds.has(weed)):
		#print("removed")
		#grabbed_weeds.erase(weed)
