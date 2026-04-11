class_name UIManager extends CanvasLayer

@export var font: Font

var tool_manager: ToolManager

@onready var game_over_label: RichTextLabel = $GameOverText
var game_over_text
var game_over_prefix = "[font=res://Fonts/KiwiSoda.ttf][center][font_size=64]
[color=#ca7ef2][outline_color=#4e278c][outline_size=16][tornado radius=15.0 freq=5.0 connected=1]"
var game_over_postfix = "[/tornado][/outline_size][/outline_color][/color][/font_size][/center][/font]"

@onready var score_text: RichTextLabel = $ScoreText
var score_prefix = "[font=res://Fonts/KiwiSoda.ttf][left][font_size=48]
[color=#ca7ef2][outline_color=#4e278c][outline_size=16][wave amp=25.0 freq=5.0 connected=1]"
var score_postfix = "[/wave][/outline_size][/outline_color][/color][/font_size][/left][/font]"
var high_score_prefix = "[font=res://Fonts/KiwiSoda.ttf][center][font_size=48]
[color=#ca7ef2][outline_color=#4e278c][outline_size=16][wave amp=50.0 freq=10.0 connected=1][rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]"
var high_score_postfix = "[/rainbow][/wave][/outline_size][/outline_color][/color][/font_size][/center][/font]"
var text_freq: float
var text_amplitude: float

@onready var combo_text: RichTextLabel = $ComboText
var combo_prefix = "[font=res://Fonts/KiwiSoda.ttf][center][font_size=16]
[color=#ca7ef2][outline_color=#4e278c][outline_size=8][wave amp=25.0 freq=5.0 connected=1]"
var combo_postfix = "[/wave][/outline_size][/outline_color][/color][/font_size][/center][/font]"
var shake_rate: float

@onready var hand_tool_button: TextureButton = $HandToolButton
@onready var hand_outline: ColorRect = $HandToolButton/Outline
@onready var scythe_tool_button: TextureButton = $ScytheToolButton
@onready var scythe_outline: ColorRect = $ScytheToolButton/Outline
var outline_scale

@onready var retry_background: NinePatchRect = $RetryBackground
@onready var retry_button: Button = $RetryBackground/RetryButton
@onready var exit_background: NinePatchRect = $ExitBackground
@onready var exit_button: Button = $ExitBackground/ExitButton

@onready var dandelion_id: TextureRect = $Identifiers/Dandelion
@onready var thistle_id: TextureRect = $Identifiers/Thistle
@onready var latus_id: TextureRect = $Identifiers/Latus
@onready var tree_id: TextureRect = $Identifiers/Tree
@onready var corn_id: TextureRect = $Identifiers/Corn
@onready var identifiers: Dictionary = {Game_Enums.Weeds.DANDELION: dandelion_id,
								Game_Enums.Weeds.THISTLE: thistle_id,
								Game_Enums.Weeds.LATUS: latus_id,
								Game_Enums.Weeds.TREE: tree_id,
								Game_Enums.Weeds.CORN: corn_id}
@onready var white: Color = Color(1, 1, 1, 1)
@onready var transparent: Color = Color(1, 1, 1, 0)


var tween_time: float = 0.4

var score: int = 1
var previous_high_score: int = 0

func _ready() -> void:
	hand_tool_button.pressed.connect(set_hand_tool)
	scythe_tool_button.pressed.connect(set_scythe_tool)
	outline_scale = hand_outline.scale
	tool_manager.new_tool.connect(_on_tool_changed)
	exit_button.pressed.connect(quit_game)
	retry_button.pressed.connect(retry_game)
	update_score(0)
	
func update_score(new_score: int):
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(_set_displayed_score.bind(score_text), score, new_score, 1)
	score = new_score

func load_high_score(value: float):
	previous_high_score = value
	
func _set_displayed_score(new_score: int, _label: RichTextLabel):
	text_freq = clamp(score / 100, 0, 20)
	text_amplitude =clamp(score / 50, 0, 200)
	score_prefix = "[font=res://Fonts/KiwiSoda.ttf][left][font_size=48]
[color=#ca7ef2][outline_color=#4e278c][outline_size=16][wave amp=" + str(text_amplitude) +  "freq=" + str(text_freq) + "connected=0]"
	score_text.text = score_prefix + str(new_score) + score_postfix

func update_combo(value: int):
	shake_rate = value * 2
	combo_prefix = "[font=res://Fonts/KiwiSoda.ttf][center][font_size=32]
[color=#ca7ef2][outline_color=#4e278c][outline_size=16][shake rate=" + str(shake_rate) + " level=5 connected=1]"
	combo_postfix = "[/shake][/outline_size][/outline_color][/color][/font_size][/center][/font]"
	if(value >= 10):
		combo_prefix += "[rainbow freq=1.0 sat=0.8 val=0.8 speed=1.0]"
		combo_postfix = "[/rainbow]" + combo_postfix
	combo_text.text = combo_prefix + str(value) + "X" + combo_postfix
	
func _set_displayed_combo():
	pass
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

func reveal_identifier(weed: Game_Enums.Weeds) -> bool:
	var tween = create_tween()
	tween.tween_property(identifiers[weed], "modulate", white, 0.25)
	await tween.finished
	return true

func hide_ui():
	var tween = create_tween().set_parallel()
	for weed in identifiers.keys():
		tween.tween_property(identifiers[weed], "modulate", transparent, 0.25)
	tween.tween_property(score_text, "modulate", transparent, 0.25)
	tween.tween_property(combo_text, "modulate", transparent, 0.25)

func display_game_over():
	if(score > previous_high_score):
		game_over_text = game_over_prefix + "Game Over!" + game_over_postfix + high_score_prefix + "
		\nHigh Score: " + str(score)
	else:
		game_over_text = game_over_prefix + "Game Over!" + game_over_postfix + combo_prefix + "
		Score: " + str(score) + "
		High Score: " + str(previous_high_score)
		
	hide_ui()
	game_over_label.text = game_over_text
	game_over_label.visible = true
	
	retry_background.visible = true
	exit_background.visible = true

func retry_game():
	get_tree().reload_current_scene()
func quit_game():
	get_tree().quit()
