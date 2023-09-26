extends TileMap


@export var cell_positions: Array[Vector2i] = [Vector2i(203, 5), Vector2i(203, 2), Vector2i(203, -1)]


func _ready():
	GameEvents.boss_defeated.connect(on_boss_defeated)

func on_boss_defeated() -> void:
	await get_tree().create_timer(3.0).timeout
	for cell_position in cell_positions:
		var smoke := preload("res://vfx/magic_dust.tscn").instantiate()
		smoke.position = map_to_local(cell_position)
		smoke.z_index = z_index - 1
		get_node("/root/World").add_child(smoke)
		set_cell(0, cell_position,8, Vector2i(0, 3))

