extends CharacterBody2D

@export var speed = 100

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("a"):
		velocity.x = -1
	if Input.is_action_pressed("d"):
		velocity.x = 1
	if Input.is_action_pressed("w"):
		velocity.y = -1
	if Input.is_action_pressed("s"):
		velocity.y = 1
	if Input.is_action_pressed("space"):
		velocity = Vector2.ZERO
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
