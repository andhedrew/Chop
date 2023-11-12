
extends CanvasLayer

@export var debug := false


func _process(_delta):
	if debug:
		visible = true
	else:
		visible = false
	
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	if debug:
		$FPS.text = "FPS " + str(Engine.get_frames_per_second())
		
	match debug:
		true:
			var player := $"../Player"
			if player:
#				$"../Player".has_booster_upgrade = true
#				$"../Player".torch_charges = 100
				$"../Player".max_health = 20
				$"../Player".health = 20
			$"../Camera".limit_left = -10000000
			$"../Camera".limit_right = 10000000
			$"../Camera".limit_top = -10000000
			$"../Camera".limit_bottom = 10000000
		false:
			$"../Camera".set_camera_limits()
