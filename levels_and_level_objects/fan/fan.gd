@tool

extends Node2D

var push_strength = 60.0  # Adjust this value to change the strength of the push
var bodies_in_fan = []  # Array to store bodies in the fan
@export var rusty := false
var activating := false
@export var max_speed = 200  # replace with your maximum speed

func _ready():
	if not Engine.is_editor_hint():
		if rusty:
			$BlowParticles.emitting = false
			activating = false
			$AnimatedSprite2D.animation = "rusty"
		else:
			SoundPlayer.play_sound_positional("fan_running", position, 140)
			SoundPlayer.play_sound_positional("fan_blow", position, 250)

		$Area2D.body_entered.connect(_on_body_entered)
		$Area2D.body_exited.connect(_on_body_exited)
		$Hurtbox.area_entered.connect(_on_area_entered_hurtbox)
		
		


func _physics_process(delta):

	if rusty:
		if activating:
			SoundPlayer.play_sound("metal_clang")
			SoundPlayer.play_sound_positional("fan_running", position, 140)
			SoundPlayer.play_sound_positional("fan_blow", position, 250)
			$RustParticles.restart()
			$AnimatedSprite2D.animation = "default"
			$BlowParticles.emitting = true
			rusty = false
			activating = false
	else:
		for body in bodies_in_fan:
			var direction = Vector2.UP.rotated(rotation)
			body.velocity += direction * push_strength
			var speed = body.velocity.length()
			if speed > max_speed:
				body.velocity = body.velocity.normalized() * max_speed
	
	if Engine.is_editor_hint():
		if rusty:
			$AnimatedSprite2D.animation = "rusty"
		else:
			$AnimatedSprite2D.animation = "default"


func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_in_fan.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_in_fan:
		bodies_in_fan.erase(body)


func _on_area_entered_hurtbox(area) -> void:
	if area is HitBox:
		if rusty:
			if area.execute:
				activating = true
