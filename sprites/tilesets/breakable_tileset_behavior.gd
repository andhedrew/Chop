extends TileMap

var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")
@export var particle_texture: Texture

func _destroy_tile(global_pos: Vector2) -> void:
#	var tile_coords = local_to_map(to_local(global_pos))
	var tile_coords = global_pos
	if get_cell_tile_data(0, tile_coords):
		set_cell(0, Vector2i(tile_coords.x, tile_coords.y), -1)
		BetterTerrain.update_terrain_cell(self, 0, Vector2i(tile_coords.x, tile_coords.y), true)
		var slice = slice_scene.instantiate()
		get_parent().add_child(slice)
		slice.position = to_global(map_to_local(tile_coords))
		var explode = particle_scene.instantiate()
		explode.restart()
		explode.texture = particle_texture
		var width : int = particle_texture.get_width() / 16
		explode.material.set_particles_anim_h_frames(width)
		get_parent().add_child(explode)
		explode.position = to_global(map_to_local(tile_coords))
		
		var cell_size := 16
		var num_particles = 12
		explode.amount = num_particles
		
		explode.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
		explode.process_material.emission_box_extents = Vector3(cell_size, cell_size, 0)
