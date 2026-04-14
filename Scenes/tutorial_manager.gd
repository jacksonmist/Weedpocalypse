extends CanvasLayer

var tut_enabled: bool = true
var save_path = "user://weedpocalypse.save"
@onready var skip_button: TextureButton = $SkipButton
@onready var continue_button: TextureButton = $ContinueButton
@onready var weed_manager: WeedManager = %WeedManager
@onready var pause_weed_timer: Timer = $PauseWeed
@onready var spotlight: ColorRect = $Spotlight
@onready var tutorial_text: RichTextLabel = $TutorialText
var weed_instance
var step: int = 0
var can_advance: bool

var tutorial_steps = ["Welcome to Weedpocalypse!",
						"This is a weed",
						"Identify it to find its weakness",
						"Make sure your tool is correct",
						"Grab and yank the weed!",
						"Good Job!\nPress play to continue"]


func _ready() -> void:
	load_data()
	if(!tut_enabled):
		end_tutorial()
		return
	
	start_tutorial()
	pause_weed_timer.timeout.connect(pause_weed)
	pause_weed_timer.start()
	skip_button.pressed.connect(end_tutorial)
	continue_button.pressed.connect(advance_tutorial)
	advance_tutorial()

func start_tutorial():
	visible = true
	weed_instance = weed_manager.spawn_tutorial_weed()

func advance_tutorial():
	tutorial_text.text = tutorial_steps[step]
	spotlight_controller()
	if(step >= tutorial_steps.size() - 1):
		return
	
	step+=1
	
func spotlight_controller():
	match step:
		2:
			var tween = create_tween().set_parallel().set_trans(Tween.TRANS_ELASTIC)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_size", value),
				1.0, 0.15, 1
			)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_position", value),
				Vector2(0.5, 0.5), Vector2(0.88, 0.07), 1
			)
		3:
			var tween = create_tween().set_parallel().set_trans(Tween.TRANS_ELASTIC)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_size", value),
				0.15, 0.11, 1
			)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_position", value),
				Vector2(0.88, 0.07), Vector2(0.125, 0.68), 1
			)
		4:
			var tween = create_tween().set_parallel().set_trans(Tween.TRANS_ELASTIC)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_size", value),
				0.11, 0.5, 1
			)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_position", value),
				Vector2(0.125, 0.68), Vector2(0.5, 0.5), 1
			)
			continue_button.visible = false
			await tween.finished
			if(weed_instance):
				weed_instance.set_physics_process(true)
			%WeedManager.weed_grow(false)
		5:
			var tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
			tween.tween_method(
				func(value): spotlight.material.set_shader_parameter("circle_size", value),
				0.5, 1, 1
			)
			skip_button.change_text("Play!")
		
func pause_weed():
	weed_manager.weed_grow(false)
	weed_instance.set_physics_process(false)
	advance_tutorial()
	
func end_tutorial():
	%WeedManager.clear_all_weeds()
	tut_enabled = false
	save_data()
	visible = false
	%WeedManager.enable_spawning()
	
func save_data():
	SaveManager.data["tutorial_enabled"] = tut_enabled
	SaveManager.save_data()
func load_data():
	tut_enabled = SaveManager.data["tutorial_enabled"]
