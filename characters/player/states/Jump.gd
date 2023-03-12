extends State

func physics_update(delta: float) -> void:

	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	
	var jump_release := Input.is_action_just_released("jump")
	var jump := Input.is_action_pressed("jump")
	
	if jump_release and owner.velocity.y < (owner.jump_height/2):
		owner.velocity.y = owner.jump_height/2
	elif jump and owner.is_on_floor():
		owner.velocity.y = owner.jump_height
		
	owner.velocity.x = owner.speed * input_direction_x
	owner.velocity.y += owner.gravity * delta
	owner.move_and_slide()
	
	if owner.velocity.y > 0:
		state_machine.transition_to("Fall")
