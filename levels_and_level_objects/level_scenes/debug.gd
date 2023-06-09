extends CanvasLayer

var debug := false

func _process(_delta):
	if debug:
		$DebugMode.visible = true
	else:
		$DebugMode.visible = false
	
	if Input.is_action_just_pressed("debug"):
		debug = !debug
	
	match debug:
		true:
			$"../Player".has_booster_upgrade = true
			$"../Player".torch_charges = 100
