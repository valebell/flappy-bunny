extends Node

const GROUP_PIPES = "pipes"
const GROUP_GROUNDS = "grounds"
const GROUP_BIRDS = "birds"

const MAX_SCORE = 99999999

const MEDAL_BRONZE = 10
const MEDAL_SILVER = 20
const MEDAL_GOLD = 30
const MEDAL_PLATINUM = 40

var score_current = 0 setget _set_score_current
var score_best = 0 setget _set_score_best
var nb_retry = 0
var selected_perso = 0
var config_file = ConfigFile.new()
var save_path = "user://config.cfg"
var conf_data = {
	"user": {
		"best": 0,
		"last_selected_character": 0,
		"retries": 0
	}
}

signal score_current_updated
signal score_best_updated

func _ready() -> void:
	loadBestScore()
	StageManager.connect("stage_change", self, "_on_stage_changed")
	pass

func has_bird():
	return score_best >= 37

func _on_stage_changed():
	score_current = 0
	pass

func _set_score_best(new_value):
	if new_value > score_best:
		score_best = new_value
		emit_signal("score_best_updated")
	pass

func _set_score_current(new_value):
	score_current = new_value
	_set_score_best(score_current)
	saveInPrefs()
	emit_signal("score_current_updated")
	pass 

func set_selected_character(new_value):
	self.selected_perso = new_value
	saveInPrefs()

func saveInPrefs():
	var conf_data = {
		"user": {
			"best_score": score_best,
			"last_selected_character": selected_perso,
			"retries": nb_retry
		}
	}
	for section in conf_data.keys():
		for key in conf_data[section]:
			config_file.set_value(section, key, conf_data[section][key])
	config_file.save(save_path)

func loadBestScore():
	var error = config_file.load(save_path)
	if error != OK:
		return
	score_best = config_file.get_value("user", "best_score", 0)
	selected_perso = config_file.get_value("user", "last_selected_character", 0)
	nb_retry = config_file.get_value("user", "retries", 0)
