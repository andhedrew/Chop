extends State

func enter(_msg := {}) -> void:
	pass


func physics_update(delta: float) -> void:


	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")

	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
