extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.boss_defeated.connect(on_boss_defeated)


func on_boss_defeated() -> void:
	await get_tree().create_timer(3.0).timeout
	var smoke := preload("res://vfx/magic_dust.tscn").instantiate()
	var cell_position := Vector2i(203, 5)
	smoke.position = map_to_local(cell_position)
	smoke.z_index = z_index + 1
	get_node("/root/World").add_child(smoke)
	set_cell(0, cell_position,1, Vector2i(6, 8))
	smoke = preload("res://vfx/magic_dust.tscn").instantiate()
	cell_position = Vector2i(203, 0)
	smoke.position = map_to_local(cell_position)
	smoke.z_index = z_index - 1
	get_node("/root/World").add_child(smoke)
	set_cell(0, cell_position,1, Vector2i(6, 8))
