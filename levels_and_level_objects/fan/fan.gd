extends Node2D

var push_strength = 60.0  # Adjust this value to change the strength of the push
var player_in_fan := false
var player_scene

@export var max_speed = 200  # replace with your maximum speed


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	SoundPlayer.play_sound_positional("fan_running", position, 140)
	SoundPlayer.play_sound_positional("fan_blow", position, 250)
	
	
func _physics_process(delta):
	
	if player_in_fan:
		var direction = Vector2.UP.rotated(rotation)
		player_scene.velocity += direction * push_strength

		var speed = player_scene.velocity.length()
		
		if speed > max_speed:
			player_scene.velocity = player_scene.velocity.normalized() * max_speed


func _on_body_entered(body) -> void:
	if body is Player:
		player_scene = body
		player_in_fan = true


func _on_body_exited(body) -> void:
	if body is Player:
		player_in_fan = false
