extends Area2D

# NEEDS: directions



# Set the upward force to apply
@export var upward_force = Vector2(0, -10)
var player_in_area := false
var player = null
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	var visibility_rect = $GPUParticles2D.visibility_rect
	visibility_rect.size = $CollisionShape2D.shape.extents * 2


func _physics_process(delta):
	if player_in_area:
	
		player.velocity += upward_force
		player.velocity.y = clamp(player.velocity.y, -250, 0)
		print_debug(str(player.velocity.y))
	else:
		pass

func _on_body_entered(body):
	if body is Player:
		player_in_area = true
		player = body


func _on_body_exited(body):
	if body is Player:
		player_in_area = false
		player = body
