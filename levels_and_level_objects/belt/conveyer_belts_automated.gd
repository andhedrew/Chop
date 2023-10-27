extends TileMap

func _ready():
	var used_cells = self.get_used_cells_by_id(0)  # assuming the tiles are on layer 0
	for cell in used_cells:
		create_static_body(cell)

func create_static_body(cell):
	var static_body = StaticBody2D.new()
	self.add_child(static_body)
	static_body.global_position = self.map_to_local(cell)
	if BetterTerrain.get_cell(self, 0, cell) == 0:
		static_body.constant_linear_velocity.x = 100
	else: 
		static_body.constant_linear_velocity.x = -100
	var collision_shape = CollisionShape2D.new()
	static_body.add_child(collision_shape)
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16.0, 16.0)
	collision_shape.shape = shape
