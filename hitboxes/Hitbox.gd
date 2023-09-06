extends Area2D
class_name HitBox
var tileSize = Vector2(16, 16)

@export var damage: int = 1 
@export var execute : bool = false
@export var syphon : bool = false
@export var fire : bool = false

func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.name == "Breakable":
		var collisionShape = $CollisionShape2D.shape
		var extents = collisionShape.extents
		var topLeft = (global_position - extents) / tileSize
		var bottomRight = (global_position + extents) / tileSize

		for x in range(floor(topLeft.x), ceil(bottomRight.x)):
			for y in range(floor(topLeft.y), ceil(bottomRight.y)):
				var tilePos = Vector2i(x, y)
				if body.get_used_cells(0).has(tilePos):
					body._destroy_tile(tilePos)

