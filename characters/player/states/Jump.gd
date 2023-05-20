extends State

var coyote_jump: bool = false

func physics_update(delta: float) -> void:
	
	var jump_release := Input.is_action_just_released("jump")
	var jump := Input.is_action_pressed("jump")
	
	if jump_release and owner.velocity.y < (owner.jump_height/2):
		owner.velocity.y = owner.jump_height/2
	elif jump and owner.is_on_floor():
		owner.velocity.y = owner.jump_height
	elif coyote_jump:
		owner.velocity.y = owner.jump_height
		coyote_jump = false
		
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	
	if owner.velocity.y > 0:
		state_machine.transition_to("Fall")
	
	if owner.is_on_floor() and is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif owner.is_on_floor():
		state_machine.transition_to("Move")
	
	if Input.is_action_pressed("down") and Input.is_action_pressed("jump"):
		state_machine.transition_to("Execute")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	
	if Input.is_action_just_pressed("syphon"):
		state_machine.transition_to("Syphon")
		
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")
