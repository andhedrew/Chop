extends Area2D

# Set the upward force to apply
@export var upward_force = Vector2(0, -10)
var player_in_area := false
var player = null
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)


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
