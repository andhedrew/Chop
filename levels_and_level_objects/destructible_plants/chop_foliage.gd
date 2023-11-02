extends Sprite2D

@export var death_sound: AudioStreamWAV = null

func _ready():
	$Hurtbox.area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		var particles := preload("res://vfx/dynamic_scenery_particles.tscn").instantiate()
		if death_sound:
			SoundPlayer.play_sound_positional(death_sound, global_position)
		else:
			SoundPlayer.play_sound_positional("dirt", global_position)
		particles.texture = texture
		particles.restart()
		particles.position = global_position
		particles.z_index = z_index
		get_node("/root/World").add_child(particles)
		_destroy()


func _destroy() -> void:
	queue_free()
