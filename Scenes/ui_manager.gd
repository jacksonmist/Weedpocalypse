class_name UIManager extends CanvasLayer

var tool_manager: ToolManager
@onready var hand_tool_button: TextureButton = $HandToolButton
@onready var hand_outline: ColorRect = $HandToolButton/Outline
@onready var scythe_tool_button: TextureButton = $ScytheToolButton
@onready var scythe_outline: ColorRect = $ScytheToolButton/Outline
var outline_scale

var tween_time: float = 0.4

var score: int

func _ready() -> void:
	hand_tool_button.pressed.connect(set_hand_tool)
	scythe_tool_button.pressed.connect(set_scythe_tool)
	outline_scale = hand_outline.scale
	tool_manager.new_tool.connect(_on_tool_changed)
	
func update_score(new_score: int):
	score = new_score

func set_tool_manager(ref: ToolManager):
	tool_manager = ref
	
func _on_tool_changed(tool: Game_Enums.Tool):
	match tool:
		Game_Enums.Tool.HAND:
			set_hand_tool()
		Game_Enums.Tool.SCYTHE:
			set_scythe_tool()

func set_hand_tool():
	var tween = make_tween()
	tween.tween_property(hand_outline, "scale", outline_scale, tween_time)
	tween.tween_property(scythe_outline, "scale", Vector2(0,0), tween_time)
func set_scythe_tool():
	var tween = make_tween()
	tween.tween_property(scythe_outline, "scale", outline_scale, tween_time)
	tween.tween_property(hand_outline, "scale", Vector2(0,0), tween_time)

func make_tween() -> Tween:
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_ELASTIC)
	return tween
