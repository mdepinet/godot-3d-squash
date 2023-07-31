extends CharacterBody3D

@export var speed = 14 # m/s
@export var fall_acceleration = 75 # m/s^2
@export var jump_impulse = 20 # m/s
@export var bounce_impulse = 16 # m/s

signal hit

var MIN_SQUASH_DOT_PRODUCT = 0.15

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if (collision.get_collider() == null):
			continue # Floor collision
		if collision.get_collider().is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > MIN_SQUASH_DOT_PRODUCT:
				# Hit from above
				collision.get_collider().squash()
				target_velocity.y = bounce_impulse
			else:
				die()
	
	velocity = target_velocity
	move_and_slide()
	
	$Pivot.rotation.x = PI/6 * velocity.y / jump_impulse

func die():
	hit.emit()
	queue_free()
