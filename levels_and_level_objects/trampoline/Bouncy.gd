extends StaticBody2D

@export var speed = 300

func _ready():
#	constant_linear_velocity = -direction * speed
	$Area2D.body_entered.connect(_on_body_entered)



func _on_body_entered(body) -> void:
	var direction := Vector2.UP.rotated(rotation)
	var sprite_x_pos = $Sprite2D.position.x
	if body is Player or body is Enemy:
		var distance = abs(body.position.x - (sprite_x_pos))
		var speed_multiplier := 1.0
		if distance < 8:
			speed_multiplier = 1.3
			SoundPlayer.play_sound_positional("bounce_success", global_position)
		else:
			speed_multiplier = 1.0
			SoundPlayer.play_sound_positional("bounce_fail", global_position)
		$AnimationPlayer.play("bounce")
		body.velocity = direction * (speed * speed_multiplier)
