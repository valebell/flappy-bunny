extends CanvasLayer

signal stage_change

var is_changing = false

func change_stage(stage_path):
	if is_changing: return
	is_changing = true
	
	var anim_node = get_node("AnimationPlayer")
	anim_node.play("fade_in")
	await anim_node.animation_finished
	
	get_tree().change_scene_to_file(stage_path)
	emit_signal("stage_change")
	anim_node.play("fade_out")
	is_changing = false
	Game.nb_retry += 1
