extends Label

func _ready() -> void:
	Game.connect("score_current_updated", Callable(self, "_on_score_current_updated"))
	text = "Score: " + str(Game.score_current)

func _on_score_current_updated():
	text = "Score: " + str(Game.score_current)
	pass

