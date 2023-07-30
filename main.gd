extends Node

@export var mob_scene: PackedScene

var MIN_SPAWN_DISTANCE = 5 # m

func _ready():
	$UI/Retry.hide()

func _on_spawn_timer_timeout():
	if (should_spawn()):
		spawn_mob()

func should_spawn():
	return true

func spawn_mob():
	var mob = mob_scene.instantiate()
	var spawn_loc = $SpawnPath/SpawnLocation
	spawn_loc.progress_ratio = randf()
	while spawn_loc.position.distance_to($Player.position) < MIN_SPAWN_DISTANCE:
		spawn_loc.progress_ratio = randf()
	mob.initialize(spawn_loc.position, $Player.position)
	add_child(mob)
	mob.squashed.connect($UI/ScoreLabel._on_mob_squashed.bind())


func _on_player_hit():
	$SpawnTimer.stop()
	$UI/Retry.show()


func _on_retry():
	get_tree().reload_current_scene()
