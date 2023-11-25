extends State

@onready var jump_buffer_timer := $"../../JumpBufferTimer"
@onready var coyote_timer := $"../../CoyoteTimer"

func enter(_msg := {}) -> void:
	# owner.collision_mask |= (1 << 7)
	owner.execute_disabled = false
	$"../../BoosterPivot".visible = false
	$"../../BrickBasher".set_deferred("monitoring", false)
	$"../../BrickBasher".set_deferred("monitorable", false)


func physics_update(_delta: float) -> void:
	if owner.in_water:
		owner.velocity.x = lerp(owner.velocity.x, owner.belt_speed, Param.WATER_FRICTION)
	else:
		owner.velocity.x = lerp(owner.velocity.x, owner.belt_speed, Param.FRICTION)
	
	owner.move_and_slide()

	if not owner.is_on_floor():
		coyote_timer.start()
		state_machine.transition_to("Fall")
		return

	if Input.is_action_just_pressed("jump") or !jump_buffer_timer.is_stopped():
		state_machine.transition_to("Jump")
		jump_buffer_timer.stop()
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Move")

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")

	if Input.is_action_just_pressed("syphon"):
		state_machine.transition_to("Syphon")

	
	if Input.is_action_just_pressed("down"):
		owner.position.y += 1
