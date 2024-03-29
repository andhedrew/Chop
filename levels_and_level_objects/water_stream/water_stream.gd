extends Node2D
@export var speed = 100
var push_strength = 60.0  # Adjust this value to change the strength of the push
var bodies_in_stream = [] 
@export var max_speed = 200  # replace with your maximum speed
# Speed of movement in pixels
var pixel_speed := 16
# Time in seconds for each movement
var move_interval := 0.16



func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$MovementTimer.wait_time = move_interval
	$MovementTimer.timeout.connect(_on_movement_timer_timeout)


func _physics_process(_delta):
	for body in bodies_in_stream:
		var direction = Vector2.UP.rotated(rotation)
		body.velocity += direction * push_strength
		var speed = body.velocity.length()
		if speed > max_speed:
			body.velocity = body.velocity.normalized() * max_speed


func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_in_stream.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_in_stream:
		bodies_in_stream.erase(body)


func _on_movement_timer_timeout():
	print_debug("advanced")
	$Sprite2D.texture.region.position.x -= pixel_speed
	$MovementTimer.start()
