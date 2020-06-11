extends Node2D

const scn_pipe = preload("res://scenes/Pipe.tscn")
const scn_wall_fire = preload("res://scenes/WallFire.tscn")
const scn_bot = preload("res://scenes/Bot.tscn")
const PIPE_WIDTH = 26
const GROUND_HEIGHT = 8
const OFFSET_X = 65
const OFFSET_Y = 85
const AMOUNT_TO_FILL_VIEW = 3

var nbPipesSpawned = 0

func _ready() -> void:
	var bird = Utils.get_main_node().get_node("Bird")
	if bird:
		bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)
	pass

func start() -> void:
	nbPipesSpawned = 0
	position = init_position()

	for i in AMOUNT_TO_FILL_VIEW:
		spawn_and_move()

func spawn_and_move():
	spawn_pipe()
	position = next_position(position)

func _on_bird_state_changed(bird: Bird):
	if bird.get_state() == Bird.STATE_FLAP:
		start()
	

func init_position() -> Vector2:
	randomize()
	
	var init_position = Vector2()
	var rect = get_viewport_rect()
	init_position.x = rect.size.x + 30
	init_position.y = OFFSET_Y + 50

	var camera = Utils.get_main_node().get_node("Camera")
	if camera:
		init_position.x += camera.get_total_position().x
	
	return init_position

func next_position(current_position: Vector2) -> Vector2:
	randomize()
	
	var next_position = current_position
	var rect = get_viewport_rect()
	next_position.x += OFFSET_X + 30
	if nbPipesSpawned >= 5:
		next_position.y = rand_range(0 + OFFSET_Y, rect.size.y - GROUND_HEIGHT - OFFSET_Y)
	else:
		next_position.y = OFFSET_Y + 50
	return next_position

func createPipe() -> Pipe:
	var new_pipe = scn_pipe.instance()
	new_pipe.position = position
	new_pipe.connect("destroyed", self, "spawn_and_move")
	return new_pipe

func createWallPipe() -> Pipe:
	var new_pipe = scn_wall_fire.instance()
	new_pipe.position = position
	new_pipe.connect("destroyed", self, "spawn_and_move")
	return new_pipe
	
func spawn_pipe():
	randomize()

	var level2 = nbPipesSpawned > 2 and nbPipesSpawned < 5
	var level3 = nbPipesSpawned >= 5 and nbPipesSpawned < 7
	var level4 = nbPipesSpawned >= 7 and nbPipesSpawned < 12
	var level5 = nbPipesSpawned >= 12 and nbPipesSpawned < 14
	var level6 = nbPipesSpawned >= 14 and nbPipesSpawned < 19
	var level7 = nbPipesSpawned >= 19 and nbPipesSpawned < 21
	var level8 = nbPipesSpawned >= 21 and nbPipesSpawned < 26
	var level9 = nbPipesSpawned >= 26 and nbPipesSpawned < 28
	var level10 = nbPipesSpawned >= 28 and nbPipesSpawned < 33
	var level11 = nbPipesSpawned >= 33
	
	if nbPipesSpawned == 0:
		var new_pipe = self.createPipe()
		new_pipe.setSpacing(Pipe.LARGE)
		get_node("Container").add_child(new_pipe)
	elif nbPipesSpawned == 1:
		var new_pipe = self.createPipe()
		new_pipe.setSpacing(Pipe.MEDIUM)
		get_node("Container").add_child(new_pipe)
	elif nbPipesSpawned == 2:
		var new_pipe = self.createPipe()
		new_pipe.setSpacing(Pipe.SMALL)
		get_node("Container").add_child(new_pipe)
	elif nbPipesSpawned == 36 and Game.selected_perso == 0:
		self.spawnBird()
		var new_pipe = self.createPipe()
		get_node("Container").add_child(new_pipe)
	elif level7 or level8 or level9 or level10:
		var new_pipe = self.createWallPipe()
		get_node("Container").add_child(new_pipe)
		if level9 or level10:
			   new_pipe.get_node("Top/AnimationPlayer").play("GrowingFire")
	elif level2 or level3 or level4 or level5 or level6:
		var new_pipe = self.createPipe()
		get_node("Container").add_child(new_pipe)
		if level5 or level6:
			new_pipe.get_node("AnimationPlayer").play("GrowingFire")
	elif level11:
		var randValue = rand_range(0, 30)
		if randValue <= 17:
			var new_pipe = self.createPipe()
			get_node("Container").add_child(new_pipe)
			if randValue < 7:
				new_pipe.get_node("AnimationPlayer").play("GrowingFire")
		else:
			var new_pipe = self.createWallPipe()
			get_node("Container").add_child(new_pipe)
			if randValue >= 25:
				new_pipe.get_node("Top/AnimationPlayer").play("GrowingFire")
	nbPipesSpawned += 1


func spawnBird():
	var bot = scn_bot.instance()
	bot.position = position
	get_node("Container").add_child(bot)
