extends AnimatableBody2D

@export var point_a: Vector2
@export var point_b: Vector2
@export var speed: float = 120.0

# If true, player will be pulled along while touching the wall.
@export var carry_bodies: bool = true

var _target: Vector2
var _last_position: Vector2
var linear_velocity: Vector2 = Vector2.ZERO  # current wall velocity (pixels/sec)

@onready var _carry_area: Area2D = $Area2D

var _carried_bodies: Array[CharacterBody2D] = []


func _ready() -> void:
	global_position = point_a
	_target = point_b
	_last_position = global_position

	_carry_area.body_entered.connect(_on_body_entered)
	_carry_area.body_exited.connect(_on_body_exited)


func _physics_process(delta: float) -> void:
	# --- Move the wall between A and B ---
	var to_target: Vector2 = _target - global_position
	var step: float = speed * delta

	if to_target.length() <= step:
		global_position = _target
		_target = point_a if _target == point_b else point_b
	else:
		global_position += to_target.normalized() * step

	# --- Compute wall velocity this frame ---
	linear_velocity = (global_position - _last_position) / max(delta, 0.00001)
	_last_position = global_position

	# --- Optionally carry any touching bodies ---
	if carry_bodies:
		for body in _carried_bodies:
			# Ask the body to use this external velocity
			if body.is_inside_tree() and body.has_method("set_platform_velocity"):
				body.set_platform_velocity(linear_velocity)


func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		_carried_bodies.append(body)


func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:
		_carried_bodies.erase(body)
