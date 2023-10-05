extends Node2D

var push_strength = 60.0  # Adjust this value to change the strength of the push
var bodies_in_fan = []  # Array to store bodies in the fan
@export var max_speed = 200  # replace with your maximum speed

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	SoundPlayer.play_sound_positional("fan_running", position, 140)
	SoundPlayer.play_sound_positional("fan_blow", position, 250)

func _physics_process(delta):
	for body in bodies_in_fan:
		var direction = Vector2.UP.rotated(rotation)
		body.velocity += direction * push_strength
		var speed = body.velocity.length()
		if speed > max_speed:
			body.velocity = body.velocity.normalized() * max_speed

func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_in_fan.append(body)

func _on_body_exited(body) -> void:
	if body in bodies_in_fan:
		bodies_in_fan.erase(body)
