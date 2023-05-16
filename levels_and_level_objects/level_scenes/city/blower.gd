extends Area2D

@export var force = Vector2(10, -10)
@export_enum("UP", "LEFT", "DOWN", "RIGHT") var blow_direction: String
var player_in_area := false
var player = null
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

	z_index = SortLayer.FOREGROUND
	
	var collision_width = collision_shape.shape.extents.x
	var collision_height = collision_shape.shape.extents.y

	

func _physics_process(delta):
	if player_in_area:
		match blow_direction:
			"UP":
				player.velocity.y += force.y
				player.velocity.y = clamp(player.velocity.y, -250, 0)
			"LEFT":
				player.velocity.x -= force.x
				player.velocity.y = clamp(player.velocity.y, 250, 0)
			"DOWN":
				player.velocity.y -= force.y
				player.velocity.x = clamp(player.velocity.x, 250, 0)
			"RIGHT":
				player.velocity.x += force.x
				player.velocity.x = clamp(player.velocity.x, -250, 0)
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
