extends State

func physics_update(delta: float) -> void:

	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += Param.GRAVITY_ON_FALL * delta
	owner.move_and_slide()

	if owner.is_on_floor() and is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif owner.is_on_floor():
		state_machine.transition_to("Walk")
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
