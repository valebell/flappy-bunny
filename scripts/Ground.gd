extends StaticBody2D

@onready var ground_end_position = get_node("ground_end_position")
@onready var camera = Utils.get_main_node().get_node("Camera3D")

signal destroyed

func _ready() -> void:
	add_to_group(Game.GROUP_GROUNDS)

func _physics_process(_delta: float) -> void:
	if camera == null: return
	if ground_end_position.global_position.x <= camera.get_total_position().x:
		queue_free()
		emit_signal("destroyed")
