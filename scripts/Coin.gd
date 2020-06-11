extends Area2D

var is_taken = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group(Game.GROUP_BIRDS) and !is_taken:
		var bird = body as Bird
		var birdState = bird.get_state()
		if birdState == Bird.STATE_HIT or birdState == Bird.STATE_GROUNDED:
			pass

		if Game.score_current < Game.MAX_SCORE:
			Game.score_current += 1
		self.get_node("sound_coin").play()
		is_taken = true
		pass
	pass
