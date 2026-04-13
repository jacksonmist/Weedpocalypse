extends Node
@onready var save_path = "user://save.json"
signal data_ready
@onready var data: Dictionary = {
	"tutorial_enabled": true,
	"highscore": 0.0,
	"seen_weeds": {},
	"music_volume": 0.0,
	"sfx_volume": 0.0
}

func _ready() -> void:
	_load_data()
	
	
func save_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()
	
func _load_data():
	if !FileAccess.file_exists(save_path):
		return
	var file = FileAccess.open(save_path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
	file.close()
