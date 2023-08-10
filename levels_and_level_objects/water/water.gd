extends Area2D

@export var force = Vector2(10, -10)
var player_in_area := false
var player = null
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var bubbles := $ColorRect/GPUParticles2D

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	z_index = SortLayer.PLAYER

func _physics_process(delta):
	if player_in_area:
		bubbles.visible = true
		bubbles.position.x = player.position.x
		bubbles.position.y = player.position.y - 30
	else:
		bubbles.visible = false

func _on_body_entered(body):
	if body is Player:
		player_in_area = true
		body.in_water = true
		player = body

func _on_body_exited(body):
	if body is Player:
		player_in_area = false
		body.in_water = false
		player = body
