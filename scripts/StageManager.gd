extends CanvasLayer

const STAGE_GAME = "res://stages/game_stage.tscn"

signal stage_change

var is_changing = false
var admob: Admob
var adLoaded = false

func _ready() -> void:
	var admob = Utils.get_main_node().get_node("Admob")
	admob.connect("interstitial_loaded", self, "on_loading_success")
	admob.connect("interstitial_failed_to_load", self, "on_loading_fail_ad")
	admob.load_interstitial()

func change_stage(stage_path):
	if is_changing: return
	is_changing = true
	
	var anim_node = get_node("AnimationPlayer")
	anim_node.play("fade_in")
	yield(anim_node, "animation_finished")
	
	get_tree().change_scene(STAGE_GAME)
	emit_signal("stage_change")
	anim_node.play("fade_out")
	is_changing = false
	
	if self.adLoaded and Game.nb_retry % 3 == 0 && Game.nb_retry > 0:
		var admob = Utils.get_main_node().get_node("Admob")
		admob.show_interstitial()
	Game.nb_retry += 1

func on_loading_fail_ad(error):
	print(error)

func on_loading_success():
	self.adLoaded = true
