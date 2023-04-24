extends AnimationPlayer


func _process(delta):
	if Input.is_action_just_pressed("1"):
		play("sunrise")
	if Input.is_action_just_pressed("2"):
		play("day")
	if Input.is_action_just_pressed("3"):
		play("sunset")
	if Input.is_action_just_pressed("4"):
		play("night")
