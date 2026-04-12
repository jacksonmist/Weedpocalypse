extends CanvasLayer

@export var font: Font

@onready var tut_button: TextureButton = $TutButton
@onready var tut_label: Label = $TutButton/TutButtonTexture/TutEnabledLabel

@onready var play_button: TextureButton = $PlayButton
@onready var quit_button: TextureButton = $QuitButton
var game_path: String = "uid://1ips1634u4wj"
var tut_enabled: bool

var highscore
var top_scores = []
@onready var leaderboard: RichTextLabel = $Leaderboard

func _ready() -> void:
	play_button.pressed.connect(start_game)
	quit_button.pressed.connect(quit_game)
	tut_button.pressed.connect(_tutorial_button)
	load_data()
	_tut_label()
	LeaderboardManager.retrieve_scores()
	await LeaderboardManager.scores_ready
	top_scores = LeaderboardManager.get_scores()
	set_leaderboard()
	
func start_game():
	SceneLoader.load_scene(game_path)

func quit_game():
	get_tree().quit()

func _tutorial_button():
	if(tut_enabled):
		tut_enabled = false
	else:
		tut_enabled = true
	_tut_label()
	save_data()

func _tut_label():
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var button_scale = Vector2.ONE if tut_enabled else Vector2.ZERO
	tween.tween_property(tut_label, "scale", button_scale, 0.2)
	
func set_leaderboard():
	for profile in top_scores:
		var key = profile.keys()[0]
		leaderboard.text += key + ": " + str(int(profile[key])) + "\n"
	leaderboard.text += '\n\n' + "You: " + str(int(highscore))
	reveal_leaderboard()

func reveal_leaderboard():
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.02
	while(leaderboard.visible_ratio <= 1.0):
		leaderboard.visible_characters += 1
		timer.start()
		await timer.timeout
	
func save_data():
	SaveManager.data["tutorial_enabled"] = tut_enabled
	SaveManager.save_data()
func load_data():
	tut_enabled = SaveManager.data["tutorial_enabled"]
	highscore = SaveManager.data["highscore"]
