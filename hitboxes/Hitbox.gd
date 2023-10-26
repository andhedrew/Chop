extends Area2D
class_name HitBox
var tileSize = Vector2(16, 16)

@export var damage: int = 1 
@export var execute : bool = false
@export var syphon : bool = false
@export var fire : bool = false
@export var lethal : bool = false
@export var causes_brick_to_crumble : bool = false
var up_facing : bool = false

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)



func _on_body_entered(body):
	if body is Enemy:
		GameEvents.player_hit_enemy.emit(body)
		get_parent().set_deferred("monitorable", false)
	elif body.name == "Breakable":
		GameEvents.bullet_hit_breakable.emit(global_position)
		var collisionShape = $CollisionShape2D.shape
		var extents = collisionShape.extents
		var topLeft = (global_position - extents) / tileSize
		var bottomRight = (global_position + extents) / tileSize
		
		for x in range(floor(topLeft.x), ceil(bottomRight.x)):
			for y in range(floor(topLeft.y), ceil(bottomRight.y)):
				var tilePos = Vector2i(x, y)
				if body.get_used_cells(0).has(tilePos):
					body._destroy_tile(tilePos, causes_brick_to_crumble)

func _on_area_entered(area) -> void:
	if area is Bullet:
		GameEvents.new_vfx.emit("res://vfx/slice_soft.tscn", area.position)  #arg 1: String reference to VX # Arg 2: Position
		area.queue_free()
