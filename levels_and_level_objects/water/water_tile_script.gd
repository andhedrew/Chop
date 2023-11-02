@tool
extends TileMap

var chance := 10
var chance_increase := 3

func _ready():
	z_index = SortLayer.WATER
	await get_tree().create_timer(0.1).timeout
	if not Engine.is_editor_hint():
		var used_cells = self.get_used_cells_by_id(0)  # assuming the tiles are on layer 0
		for cell in used_cells:
			var cell_above = Vector2(cell.x, cell.y - 1)  # get the cell above
			if self.get_cell_source_id(0, cell_above) == -1:  # if there's no tile above
				pass
#				create_area2d(cell)

func _physics_process(delta):
	if Engine.is_editor_hint():
		if position != Vector2(8,8):
			position = Vector2(8,8)


#func create_area2d(cell_pos):
#	var area = Area2D.new()
#	var script = preload("res://levels_and_level_objects/water/water_area.gd")
#	self.add_child(area)
#	area.global_position = self.map_to_local(cell_pos)
#	var collision_shape = CollisionShape2D.new()
#	area.add_child(collision_shape)
#	var shape = RectangleShape2D.new()
#	shape.size = Vector2(16.0, 16.0)
#	collision_shape.shape = shape



