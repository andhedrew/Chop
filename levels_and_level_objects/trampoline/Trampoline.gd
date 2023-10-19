extends Area2D

var push_strength = 450.0  # Adjust this value to change the strength of the push
var bodies_on_trampoline = []  # Array to store bodies in the fan
@export var max_speed = 200  # replace with your maximum speed

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _physics_process(delta):
	for body in bodies_on_trampoline:
		var direction = Vector2.UP
		body.velocity += direction * push_strength
		var speed = body.velocity.length()
		if speed > max_speed:
			body.velocity = body.velocity.normalized() * max_speed


func _on_body_entered(body) -> void:
	
	if body is Player or body is Enemy:
		$AnimationPlayer.play("bounce")
		bodies_on_trampoline.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_on_trampoline:
		bodies_on_trampoline.erase(body)
