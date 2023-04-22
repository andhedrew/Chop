@tool
extends Node2D

@export var spawn : PackedScene



func _ready():
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)




func respawn():
	await get_tree().create_timer(randf_range(9.0, 12.0)).timeout
	var particles = preload("res://vfx/spawn_particles.tscn").instantiate()
	add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	var new_spawn = spawn.instantiate()
	add_child(new_spawn)
