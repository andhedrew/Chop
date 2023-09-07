extends TileMap

var particle_scene = preload("res://vfx/dirt_explode.tscn")
func _deflect(position) -> void:
	SoundPlayer.play_sound("ping")
	SoundPlayer.play_sound("dirt")
	var dirt = particle_scene.instantiate()
	get_parent().add_child(dirt)
	dirt.restart()
	dirt.amount = randf_range(2,4)
	dirt.position = position
