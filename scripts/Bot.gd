# Bird.gd

extends RigidBody2D

class_name Bot

const STATE_FLYING = 0
const STATE_FLAP = 1
const STATE_HIT = 2
const STATE_GROUNDED = 3

@onready var state = FlyingState.new(self)

signal state_changed

var speed = 20
var prev_state = STATE_FLYING

func _ready() -> void:
	self.set_state(STATE_FLYING)

func _physics_process(delta: float) -> void:
	state.update(delta)

func _on_body_entered(body: Node) -> void:
	if state.has_method("on_body_entered"):
		if body is Bird:
			self.get_node("sound_hit").play() 
		state.on_body_entered(body)
	pass

func set_state(new_state) -> void:
	self.prev_state = get_state()
	state.exit()
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAP:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	emit_signal("state_changed", self)

func get_state():
	if state is FlyingState:
		return STATE_FLYING
	elif state is FlappingState:
		return STATE_FLAP
	elif state is HitState:
		return STATE_HIT
	else:
		return STATE_GROUNDED

# Flying State ----------------------------------------------------------------

class FlyingState:
	
	var _bird
	var prev_gravity_scale
	
	func _init(bird) -> void:
		self._bird = bird
		
		prev_gravity_scale = _bird.gravity_scale
		_bird.linear_velocity = Vector2(_bird.speed, _bird.linear_velocity.y)
		_bird.gravity_scale = 0
		_bird.get_node("AnimationPlayer").play("flying")
		pass
	
	func on_body_entered(other_body: Node):
		if other_body.is_in_group(Game.GROUP_PIPES) or other_body.is_in_group(Game.GROUP_BIRDS):
			_bird.set_state(STATE_HIT)
		elif other_body.is_in_group(Game.GROUP_GROUNDS):
			_bird.set_state(STATE_GROUNDED)
		pass
		
	func update(_delta) -> void:
		pass

	func input(_event) -> void:
		pass

	func exit() -> void:
		_bird.gravity_scale = prev_gravity_scale
		_bird.get_node("AnimationPlayer").stop()
		_bird.get_node("AnimatedSprite2D").position = Vector2.ZERO
		pass

# Flapping State ----------------------------------------------------------------

class FlappingState:
	
	var _bird
	
	func _init(bird) -> void:
		self._bird = bird
		flap()
		pass

	func update(_delta) -> void:
		if Input.is_action_just_released("jump"):
			flap()
		elif Input.is_action_pressed("jump"):
			dash()
			return

		if _bird.rotation_degrees < -30:
			_bird.angular_velocity = 0
		if _bird.linear_velocity.y > 0:
			_bird.angular_velocity = 1.5
		pass

	func dash():
		_bird.get_node("AnimationPlayer").play("sprint")
		_bird.angular_velocity = 0
		_bird.rotation_degrees = 0
		if _bird.speed <= 200:
			_bird.speed = _bird.speed * 1.1
		_bird.linear_velocity = Vector2(_bird.speed, -10)

	func on_body_entered(other_body: Node):
		if other_body.is_in_group(Game.GROUP_PIPES):
			_bird.set_state(STATE_HIT)
		elif other_body.is_in_group(Game.GROUP_GROUNDS):
			_bird.set_state(STATE_GROUNDED)
		pass

	func flap():
		var yVelocity = -200 - _bird.speed
		if (yVelocity < -300):
			yVelocity = -300
		_bird.speed = 50
		_bird.linear_velocity = Vector2(_bird.speed, yVelocity)
		_bird.angular_velocity = -3
		_bird.get_node("AnimationPlayer").play("flap")
		_bird.get_node("sound_jump").play() 

	func exit() -> void:
		pass

# Hit State ----------------------------------------------------------------

class HitState:
	
	var _bird: Bot
	
	func _init(bird) -> void:
		_bird = bird
		_bird.linear_velocity = Vector2.ZERO
		_bird.angular_velocity = 0
		var other_body = _bird.get_colliding_bodies()[0]
		_bird.add_collision_exception_with(other_body)
		_bird.get_node("AnimationPlayer").play("die")
		_bird.get_node("AnimationPlayer").queue("dead")
		pass

	func on_body_entered(other_body: Node):
		if other_body.is_in_group(Game.GROUP_GROUNDS):
			_bird.set_state(STATE_GROUNDED)
		pass

	func update(_delta) -> void:
		pass

	func input(_event) -> void:
		pass

	func exit() -> void:
		pass

# Grounded State ----------------------------------------------------------------

class GroundedState:
	
	var _bird
	
	func _init(bird: Bot) -> void:
		_bird = bird
		_bird.linear_velocity = Vector2.ZERO
		if bird.prev_state != bird.STATE_HIT:
			_bird.get_node("AnimationPlayer").play("die")
			_bird.get_node("AnimationPlayer").queue("dead")
			_bird.get_node("sound_hit").play() 
		pass

	func update(_delta) -> void:
		pass

	func input(_event) -> void:
		pass

	func exit() -> void:
		pass
