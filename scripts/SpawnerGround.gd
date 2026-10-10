extends Node2D

const scn_ground = preload("res://scenes/Ground.tscn")
const GROUND_WIDTH = 168
const AMOUNT = 2

func _ready() -> void:
	for i in range(AMOUNT):
		spawn_and_move()

func spawn_and_move():
	spawn_ground()
	move_to_next_position()

func spawn_ground():
	var new_ground = scn_ground.instantiate()
	new_ground.position = position
	new_ground.connect("destroyed", Callable(self, "spawn_and_move"))
	get_node("Container").add_child(new_ground)

func move_to_next_position():
	position += Vector2(GROUND_WIDTH, 0)
