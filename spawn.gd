extends Node2D


func _ready():
	z_index = SortLayer.PLAYER
	var spawn_object := get_child(0)
	spawn_object.global_position = position


func respawn(file_path: String):
	await get_tree().create_timer(2.0).timeout
	var particles = preload("res://vfx/spawn_particles.tscn").instantiate()
	add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await get_tree().create_timer(1.0).timeout
	var new_spawn = load(file_path).instantiate()
	add_child(new_spawn)
