extends Marker2D

func _ready():
	$AnimationPlayer.play("booster")

func _process(delta):
	if $"../StateMachine".state.name == "Dash":
		$"../Pivot/Aura".visible = true
		var direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()
		if direction != Vector2.ZERO:
			rotation = direction.angle()  + deg_to_rad(90)
			$Booster.visible = true
		else:
			$Booster.visible = false
	else:
		$Booster.visible = false
		$"../Pivot/Aura".visible = false
