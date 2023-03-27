extends Marker2D

func _ready():
	pass
	$AnimationPlayer.play("booster")

func _process(delta):
	$Booster.visible = true
	if $"../StateMachine".state.name == "Dash":
		var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
		if direction != Vector2.ZERO:
			rotation = direction.angle()  + deg_to_rad(90)
			if rotation > deg_to_rad(0) and rotation < deg_to_rad(180):
				scale.x = -1
			else:
				scale.x = 1
			$Booster.position.y = 15
#			if rotation == deg_to_rad(0) or rotation == deg_to_rad(90) or rotation == deg_to_rad(180) or rotation == deg_to_rad(270):
#				$Booster.texture = preload("blowtorch.png")
#			else:
#				$Booster.texture = preload("blowtorch_angle.png")
		else:
			$Booster.position.y = 5
	else:
		$Booster.visible = false
