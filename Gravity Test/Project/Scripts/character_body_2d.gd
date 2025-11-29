extends CharacterBody2D

@export var speed = 100

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("a"):
		if velocity == Vector2.ZERO:
			velocity = Vector2(-1, 0)
	if Input.is_action_pressed("d"):
		if velocity == Vector2.ZERO:
			velocity = Vector2(1, 0)
	if Input.is_action_pressed("w"):
		if velocity == Vector2.ZERO:
			velocity = Vector2(0, -1)
	if Input.is_action_pressed("s"):
		if velocity == Vector2.ZERO:
			velocity = Vector2(0, 1)
	velocity *= speed
	move_and_slide()
	velocity /= speed
	check_lava_collision()

func die():
	global_position = Vector2(0, 0)
	velocity = Vector2.ZERO
func check_lava_collision() -> void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			var collider = collision.get_collider()
			if collider and collider.is_in_group("lava"):
				die()
