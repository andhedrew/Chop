extends Node2D

@export var spawn : PackedScene
var spawned := false



func _process(_delta):
	if !spawned:
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)
		spawned = true

func respawn():
	await get_tree().create_timer(2.0).timeout
	var particles = preload("res://vfx/spawn_particles.tscn").instantiate()
	add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	var new_spawn = spawn.instantiate()
	add_child(new_spawn)
