extends Camera2D

@onready var bird = Utils.get_main_node().get_node("Bird")

func _physics_process(_delta: float) -> void:
	position = Vector2(bird.position.x, position.y)

func get_total_position():
	return position + offset
