@tool
extends TileMap

var chance := 1
var chance_increase := 3
var conveyor_speed := 50.0

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
			create_conveyor_belt_area(cell)


func _physics_process(delta):
	if Engine.is_editor_hint():
		if position != Vector2.ZERO:
			position = Vector2.ZERO
#
#func create_static_body(cell_pos):
#	var static_body = StaticBody2D.new()
#	self.add_child(static_body)
#	static_body.global_position = self.map_to_local(cell_pos)
#	if BetterTerrain.get_cell(self, 0, cell_pos) == 0:
#		static_body.constant_linear_velocity.x = 50
#	else: 
#		static_body.constant_linear_velocity.x = -50
#	var collision_shape = CollisionShape2D.new()
#	static_body.add_child(collision_shape)
#	var shape = RectangleShape2D.new()
#	shape.size = Vector2(16.0, 16.0)
#	collision_shape.shape = shape


func create_conveyor_belt_area(cell_pos):
	var conveyor_belt_area = Area2D.new()
	self.add_child(conveyor_belt_area)
	conveyor_belt_area.global_position = self.map_to_local(cell_pos)

	conveyor_belt_area.set_collision_mask_value(2, true)
	conveyor_belt_area.set_collision_mask_value(3, true)
	conveyor_belt_area.set_collision_mask_value(6, true)
	
	var collision_shape = CollisionShape2D.new()
	conveyor_belt_area.add_child(collision_shape)

	var shape = RectangleShape2D.new()
	shape.extents = Vector2(8.0, 8.0)  
	collision_shape.shape = shape
	conveyor_belt_area.body_entered.connect(_on_ConveyorBelt_body_entered)
	conveyor_belt_area.body_exited.connect(_on_ConveyorBelt_body_exited)

func _on_ConveyorBelt_body_entered(body):
	var pos := Vector2(body.position.x, body.position.y)
	if BetterTerrain.get_cell(self, 0, local_to_map(pos)) == 0:
		conveyor_speed = 50
	else: 
		conveyor_speed = -50
	if body and body is CharacterBody2D:
		body.add_conveyor_velocity(conveyor_speed)


func _on_ConveyorBelt_body_exited(body):
	if body and body is CharacterBody2D:
		body.remove_conveyor_velocity()
