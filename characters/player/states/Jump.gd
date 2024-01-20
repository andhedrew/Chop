extends State

var coyote_jump: bool = false
var jump_multiplier := 1.0

func enter(_msg := {}) -> void:
	if owner.belt_detector.is_colliding():
		jump_multiplier = 1.1
	elif owner.in_water:
		jump_multiplier = 0.8
	else:
		jump_multiplier = 1.0

func physics_update(delta: float) -> void:
	var jump_release := Input.is_action_just_released("jump")
	var jump := Input.is_action_pressed("jump")
	var jump_pressed := Input.is_action_just_pressed("jump")
	var jump_height = owner.jump_height * jump_multiplier
	
	if jump_release and owner.velocity.y < (owner.jump_height/2):
		owner.velocity.y = jump_height/2
	elif jump and owner.is_on_floor():
		owner.velocity.y = jump_height
	elif jump and owner.in_water:
		var pivot_pos = $"../../WaterBoosterPivot".global_position
		var spacing := 8
		var left_pos = Vector2(pivot_pos.x-spacing, pivot_pos.y)
		var right_pos = Vector2(pivot_pos.x+spacing, pivot_pos.y)
		SoundPlayer.play_sound("bubble")
		GameEvents.new_vfx.emit("res://vfx/bubble_burst.tscn", left_pos)
		GameEvents.new_vfx.emit("res://vfx/bubble_burst.tscn", right_pos)
		owner.velocity.y = jump_height
		state_machine.transition_to("Jump")
	elif coyote_jump:
		owner.velocity.y = jump_height
		coyote_jump = false
		
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	if owner.in_water:
		owner.velocity.y += Param.WATER_GRAVITY * delta
	else:
		owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	
	if owner.is_on_ceiling() and not owner.in_water:
		SoundPlayer.play_sound("paper_crunch")
		
	if owner.velocity.y > 0:
		state_machine.transition_to("Fall")
	
	if owner.is_on_floor() and is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif owner.is_on_floor():
		state_machine.transition_to("Move")
	
	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
	
	if Input.is_action_just_pressed("execute"):
		state_machine.transition_to("Execute")
	
	if Input.is_action_just_pressed("syphon"):
		state_machine.transition_to("Syphon")
		
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")

