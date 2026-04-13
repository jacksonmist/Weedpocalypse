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
@onready var leaderboard_background: NinePatchRect = $LeaderboardBackground

@onready var title: RichTextLabel = $Title

@onready var music_slider: HSlider = $MusicSlider
var music_value: float
@onready var sfx_slider: HSlider = $SFXSlider
var sfx_value: float


func _ready() -> void:
	play_button.pressed.connect(start_game)
	quit_button.pressed.connect(quit_game)
	tut_button.pressed.connect(_tutorial_button)
	reveal_title()
	load_data()
	_tut_label()
	await get_tree().process_frame
	set_sliders()
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
	if(highscore == 0): leaderboard.text += " :("
	reveal_leaderboard()

func reveal_leaderboard():
	var timer = Timer.new()
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(leaderboard_background, "scale", Vector2.ONE, 0.4)
	add_child(timer)
	timer.wait_time = 0.02
	while(leaderboard.visible_ratio < 1.0):
		leaderboard.visible_characters += 1
		timer.start()
		await timer.timeout

func reveal_title():
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(title, "scale", Vector2.ONE, 4)
	tween.tween_property(title, "rotation", 4 * PI, 4)

func set_sliders():
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(music_slider, "value", music_value, 0.5)
	tween.tween_property(sfx_slider, "value", sfx_value, 0.5)
	await tween.finished
	music_slider.editable = true
	sfx_slider.editable = true
	music_slider.value_changed.connect(change_music)
	sfx_slider.value_changed.connect(change_sfx)

func change_music(value: float):
	AudioManager.change_music_volume(value)
func change_sfx(value: float):
	AudioManager.change_sfx_volume(value)

func save_data():
	SaveManager.data["tutorial_enabled"] = tut_enabled
	SaveManager.save_data()
func load_data():
	tut_enabled = SaveManager.data["tutorial_enabled"]
	highscore = SaveManager.data["highscore"]
	music_value = db_to_linear(SaveManager.data["music_volume"])
	sfx_value = db_to_linear(SaveManager.data["sfx_volume"])
