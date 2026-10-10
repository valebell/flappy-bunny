extends StaticBody2D

class_name Pipe

@onready var rightPosition = get_node("EndPosition")
@onready var camera = Utils.get_main_node().get_node("Camera3D")

const LARGE = 30
const MEDIUM = 20
const SMALL = 10

signal destroyed 

func _ready() -> void:
	add_to_group(Game.GROUP_PIPES)

func _physics_process(_delta: float) -> void:
	if camera == null: return
	
	if rightPosition.global_position.x <= camera.get_total_position().x:
		queue_free()
		emit_signal("destroyed")

func setSpacing(spacing):
	var top = self.get_node("Top")
	var shapeTop = self.get_node("ShapeTop")
	var bottom = self.get_node("Bottom")
	var shapeBottom = self.get_node("ShapeBottom")
	
	top.position.y -= spacing
	shapeTop.position.y -= spacing
	bottom.position.y += spacing
	shapeBottom.position.y += spacing
