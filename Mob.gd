extends CharacterBody3D

signal squashed

@export var min_speed = 10 # m/s
@export var max_speed = 18 # m/s

func initialize(start_position, player_position):
	var translated_pos = Vector3.ZERO
	translated_pos.x = player_position.x
	translated_pos.z = player_position.z
	look_at_from_position(start_position, translated_pos, Vector3.UP)
	rotate_y(randf_range(-PI/4, PI/4))
	
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed

func squash():
	squashed.emit()
	queue_free()

func _physics_process(delta):
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
