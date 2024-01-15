
extends CanvasLayer

@export var debug := false
var cheated := false

func _process(_delta):
	if debug:
		visible = true
	else:
		visible = false
	
#	if Input.is_action_just_pressed("debug"):
#		debug = !debug
	
	if debug:
		$FPS.text = "FPS " + str(Engine.get_frames_per_second())
		
	match debug:
		true:
			if not cheated:
				GameEvents.cheatmode.emit()
				cheated = true
