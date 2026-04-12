extends Node

var highscore: float
var top_scores: Dictionary

func _ready() -> void:
	highscore = SaveManager.data["highscore"]
	
	top_scores = await SilentWolf.Scores.get_scores(5).sw_get_scores_complete
	
func check_score(score: float) -> bool:
	var index_to_check = top_scores["scores"].size() - 1
	if(score > top_scores["scores"][index_to_check]["score"] or top_scores["scores"].size() < 5):
		return true
	return false

func submit_score(player_tag: String, score: float):
	SilentWolf.Scores.save_score(player_tag, score)
