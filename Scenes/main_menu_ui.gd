extends CanvasLayer

@export var font: Font

@onready var tut_button: TextureButton = $TutButton
@onready var play_button: TextureButton = $PlayButton
@onready var quit_button: TextureButton = $QuitButton
var game_path: String = "uid://1ips1634u4wj"
var tut_enabled: bool

var top_scores = []
@onready var leaderboard: RichTextLabel = $Leaderbord

func _ready() -> void:
	play_button.pressed.connect(start_game)
	quit_button.pressed.connect(quit_game)
	tut_button.pressed.connect(_tutorial_button)
	load_data()
	await LeaderboardManager.scores_ready
	top_scores = LeaderboardManager.get_scores()
	
func start_game():
	SceneLoader.load_scene(game_path)

func quit_game():
	get_tree().quit()

func _tutorial_button():
	if(tut_enabled):
		tut_enabled = false
	else:
		tut_enabled = true
	save_data()
	print(tut_enabled)

func set_leaderboard():
	return
	for profile in top_scores:
		leaderboard.text = profile[0]
	
func save_data():
	SaveManager.data["tutorial_enabled"] = tut_enabled
	SaveManager.save_data()
func load_data():
	tut_enabled = SaveManager.data["tutorial_enabled"]
