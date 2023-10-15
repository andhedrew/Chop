@tool
extends Node2D

@export var spawn : PackedScene
@export_enum("Left", "Right") var facing = "Left"
var active := true

var timer_minimum := 40.0
var timer_maximum := 80.0

func _ready():
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)
		await get_tree().create_timer(0.1).timeout
		if facing == "Left":
			new_spawn.facing = Enums.Facing.LEFT
		elif facing == "Right":
			new_spawn.facing = Enums.Facing.RIGHT
		new_spawn.set_facing(new_spawn.facing)
		GameEvents.cutscene_started.connect(_cutscene_started)
		GameEvents.cutscene_ended.connect(_cutscene_ended)

func respawn():
	await get_tree().create_timer(randf_range(timer_minimum, timer_maximum)).timeout
	if active:
		var particles = preload("res://vfx/spawn_particles.tscn").instantiate()
		add_child(particles)
		particles.position = Vector2(0,-5)
		particles.emitting = true
		SoundPlayer.play_sound_positional("spawn", position)
		await get_tree().create_timer(1.0).timeout
		var new_spawn = spawn.instantiate()
		add_child(new_spawn)
		if facing == "Left":
			new_spawn.facing = Enums.Facing.LEFT
		elif facing == "Right":
			new_spawn.facing = Enums.Facing.RIGHT
		new_spawn.set_facing(new_spawn.facing)
		new_spawn.has_respawned = true


func _cutscene_started():
	active = false
	$ActiveLabel.text = str(active)

func _cutscene_ended():
	active = true
	$ActiveLabel.text = str(active)
