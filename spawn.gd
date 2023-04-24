@tool
extends Node2D

@export var spawn : PackedScene

var active := true


func _ready():
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)
		GameEvents.cutscene_started.connect(_cutscene_started)
		GameEvents.cutscene_ended.connect(_cutscene_ended)




func respawn():
	if active:
		await get_tree().create_timer(randf_range(9.0, 12.0)).timeout
		var particles = preload("res://vfx/spawn_particles.tscn").instantiate()
		add_child(particles)
		particles.global_position = position
		particles.emitting = true
		await get_tree().create_timer(1.0).timeout
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)


func _cutscene_started():
	active = false

func _cutscene_ended():
	active = true
