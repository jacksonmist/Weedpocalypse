extends CanvasLayer

var tut_enabled: bool = true
var save_path = "user://weedpocalypse.save"
@onready var skip_button: TextureButton = $SkipButton


func _ready() -> void:
	load_data()
	if(!tut_enabled):
		end_tutorial()
		return
	
	start_tutorial()
	skip_button.pressed.connect(end_tutorial)

func start_tutorial():
	visible = true
	
func end_tutorial():
	tut_enabled = false
	save_data()
	visible = false
	%WeedManager.enable_spawning()
	
func save_data():
	SaveManager.data["tutorial_enabled"] = tut_enabled
	SaveManager.save_data()
func load_data():
	tut_enabled = SaveManager.data["tutorial_enabled"]
	print(tut_enabled)
