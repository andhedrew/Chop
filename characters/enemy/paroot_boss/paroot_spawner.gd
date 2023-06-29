extends Path2D

var scene: PackedScene = preload("res://characters/enemy/paroot/pareet.tscn") 


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.boss_stomped.connect(spawn)
	GameEvents.boss_hit_wall.connect(spawn)


func spawn() -> void:
	SoundPlayer.play_sound_positional("spit", owner.global_position)
	var new_spawn = scene.instantiate()
	get_node("/root/World").add_child(new_spawn)
	new_spawn.z_index = SortLayer.PLAYER
	var mob_spawn_location = get_node("MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	new_spawn.position = mob_spawn_location.position
	new_spawn.velocity = Vector2( 0, -30)


