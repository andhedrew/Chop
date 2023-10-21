extends Area2D

var bodies_bouncing = []  # Array to store bodies in the fan
var bounce_strength = 50

@onready var web = $Line2D



func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _physics_process(delta):
		for body in bodies_bouncing:
			var direction = body.global_position - global_position
			direction = direction.normalized()
			body.velocity += direction * bounce_strength
			var pop_strength = -150
			body.velocity.y = pop_strength



func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_bouncing.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_bouncing:
		bodies_bouncing.erase(body)
