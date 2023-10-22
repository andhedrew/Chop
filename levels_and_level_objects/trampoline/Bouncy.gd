extends StaticBody2D

@export var speed = -300

func _ready():
	var direction = Vector2.UP.rotated(rotation)
	constant_linear_velocity = -direction * speed
	$Area2D.body_entered.connect(_on_body_entered)
	
	
	
func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		$AnimationPlayer.play("bounce")
