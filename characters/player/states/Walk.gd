extends State

func enter(_msg := {}) -> void:
	pass


func physics_update(delta: float) -> void:
	if not owner.is_on_floor():
		state_machine.transition_to("Fall")
		return

	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	owner.velocity.x = owner.speed * input_direction_x
	owner.velocity.y += owner.gravity * delta
	owner.move_and_slide()

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Jump")
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
