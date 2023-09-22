extends TileMap

var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")
@export var particle_texture: Texture
@export var particle_texture_2: Texture

var tiles_to_return = []

func _destroy_tile(global_pos: Vector2) -> void:
	var cell_id = get_cell_source_id(0, global_pos)
	print_debug(str(cell_id))
	if cell_id == 2:
		print_debug("replacing tilee")
		_replace_tile(global_pos)
	elif cell_id == 1:
		
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


func _replace_tile(global_pos: Vector2) -> void:
	print_debug("replacing_tiles")
	var cell_pos = local_to_map(global_pos)
	var atlas_coords = get_cell_atlas_coords(0, global_pos)
	set_cell(0, global_pos, 3, atlas_coords)
	tiles_to_return.append(global_pos)
	
	# Start a timer for 2 seconds
	var timer = Timer.new()
	timer.set_wait_time(2.0)
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	


func _return_tile(global_pos: Vector2) -> void:
	var cell_pos = local_to_map(global_pos)
	var atlas_coords = get_cell_atlas_coords(0, global_pos)
	set_cell(0, global_pos, 2, atlas_coords)

func _on_timer_timeout() -> void:
	if tiles_to_return.size() > 0:
		_return_tile(tiles_to_return.pop_front())
