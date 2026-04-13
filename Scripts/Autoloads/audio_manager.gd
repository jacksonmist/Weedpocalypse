extends Node

var music_volume: float
var sfx_volume: float

func _ready() -> void:
	await SaveManager.ready
	_load_volumes()
	

func _load_volumes():
	music_volume = SaveManager.data["music_volume"]
	sfx_volume = SaveManager.data["sfx_volume"]
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume)

func change_music_volume(value: float):
	var db = linear_to_db(value)
	music_volume = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume)
	SaveManager.data["music_volume"] = music_volume
	SaveManager.save_data()
func change_sfx_volume(value: float):
	var db = linear_to_db(value)
	sfx_volume = db
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume)
	SaveManager.data["sfx_volume"] = sfx_volume
	SaveManager.save_data()
