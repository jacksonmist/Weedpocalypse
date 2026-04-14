extends Node

var top_scores: Dictionary
signal scores_ready
var leaderboard_active: bool = false

func retrieve_scores():
	top_scores = await SilentWolf.Scores.get_scores(5).sw_get_scores_complete
	leaderboard_active = true
	scores_ready.emit()

func check_score(score: float) -> bool:
	if(!leaderboard_active):
		return false
	var index_to_check = top_scores["scores"].size() - 1
	if(score > top_scores["scores"][index_to_check]["score"] or top_scores["scores"].size() < 5):
		return true
	return false

func submit_score(player_tag: String, score: float):
	SilentWolf.Scores.save_score(player_tag, score)

func get_scores():
	if(!leaderboard_active):
		return
	var scores_array = []
	for i in top_scores["scores"].size():
		var profile = {top_scores["scores"][i]["player_name"]: top_scores["scores"][i]["score"]}
		scores_array.append(profile)
	return scores_array
