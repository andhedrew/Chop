extends State

func physics_update(delta: float) -> void:

	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	owner.velocity.x = owner.speed * input_direction_x
	owner.velocity.y += owner.gravity * delta
	owner.move_and_slide()

	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
