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
		
		var region = Rect2(0, 64 * frame, 64, 64)
		var canvas_material = particles.material as CanvasItemMaterial
		var particle_material := particles.process_material as ParticleProcessMaterial
		
		canvas_material.particles_anim_h_frames = hframes * 2
		canvas_material.particles_anim_v_frames = 2
		
		var offset_frame = (((frame+1)) * 0.25) * 0.01
		if randf() > 0.5:
			offset_frame += 0.5
		particle_material.anim_offset_min = offset_frame
		particle_material.anim_offset_max = offset_frame
		
		
		
		
		get_node("/root/World").add_child(particles)
		_destroy()


func _destroy() -> void:
	queue_free()
