class_name MouseController extends Area2D

@onready var mouse_cursor: Sprite2D = $MouseCursor
var cursors: Dictionary = {}
@export var hand_cursor: Texture
@export var hand_pressed_cursor: Texture
@export var scythe_cursor: Texture
@export var scythe_pressed_cursor: Texture
@export var scythe_cut_animation: AnimatedSprite2D

var mouse_position: Vector2
var current_tool: Game_Enums.Tool

var grabbed_weeds: Array[Weed]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_tool = Game_Enums.Tool.HAND
	area_entered.connect(use_tool)
	monitoring = false
	#mouse_cursor.texture = hand_cursor
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	cursors[Game_Enums.Tool.HAND] = preload("res://Sprites/OpenHand.png")
	cursors[Game_Enums.Tool.SCYTHE] = preload("res://Sprites/Scythe.png")
	cursors[2] = preload("res://Sprites/ClosedHand.png")
	cursors[3] = preload("res://Sprites/ScythePressed.png")
	Input.set_custom_mouse_cursor(cursors[Game_Enums.Tool.HAND], Input.CURSOR_ARROW, Vector2.ZERO)

func _physics_process(_delta: float):
	position = get_global_mouse_position()
	
func set_tool(tool: Game_Enums.Tool):
	current_tool = tool
	Input.set_custom_mouse_cursor(cursors[tool])

func set_active(is_active: bool):
	monitoring = is_active
	if(!is_active):
		for weed in grabbed_weeds:
			if weed != null:
				weed.grab(false)
		grabbed_weeds = []
		Input.set_custom_mouse_cursor(cursors[current_tool])
	else:
		Input.set_custom_mouse_cursor(cursors[current_tool + 2])
	
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
