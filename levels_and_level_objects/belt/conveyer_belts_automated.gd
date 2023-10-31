@tool
extends TileMap

var chance := 10
var chance_increase := 3

func _ready():
	await get_tree().create_timer(0.1).timeout
	if not Engine.is_editor_hint():
		var used_cells = self.get_used_cells_by_id(0)  # assuming the tiles are on layer 0
		for cell in used_cells:
			var rand_num = randf_range(0, 100)
			if rand_num < chance:
				GameEvents.new_vfx.emit("res://vfx/oil_dripping.tscn", map_to_local(cell))
				chance = chance_increase
			else:
				chance += chance_increase
			create_static_body(cell)

func _physics_process(delta):
	if Engine.is_editor_hint():
		if position != Vector2.ZERO:
			position = Vector2.ZERO

func create_static_body(cell_pos):
	var static_body = StaticBody2D.new()
	self.add_child(static_body)
	static_body.global_position = self.map_to_local(cell_pos)
	if BetterTerrain.get_cell(self, 0, cell_pos) == 0:
		static_body.constant_linear_velocity.x = 50
	else: 
		static_body.constant_linear_velocity.x = -50
	var collision_shape = CollisionShape2D.new()
	static_body.add_child(collision_shape)
	var shape = RectangleShape2D.new()
	shape.size = Vector2(16.0, 16.0)
	collision_shape.shape = shape
