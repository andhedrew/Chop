extends TileMap

var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")
@export var particle_texture: Texture
@export var particle_texture_2: Texture

var tiles_to_return = []
var replace_tile_scene := preload("res://sprites/tilesets/replace_tile_here.tscn")

func _ready():
	GameEvents.replace_tile.connect(_return_tile)


func _destroy_tile(global_pos: Vector2) -> void:
	var cell_id = get_cell_source_id(0, global_pos)
	if cell_id == 2:
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
	var cell_pos = local_to_map(global_pos)
	var atlas_coords = get_cell_atlas_coords(0, global_pos)
	set_cell(0, global_pos, 3, atlas_coords)
	
	var replace_tile = replace_tile_scene.instantiate()
	replace_tile.position = global_pos*16
	get_node("/root/World").add_child(replace_tile)


func _return_tile(global_pos: Vector2) -> void:
	var cell_pos = local_to_map(global_pos)
	var atlas_coords = get_cell_atlas_coords(0, global_pos)
	set_cell(0, global_pos, 2, atlas_coords)
