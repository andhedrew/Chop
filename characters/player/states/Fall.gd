extends State

@onready var coyote_timer := $"../../CoyoteTimer"
@onready var jump_buffer_timer := $"../../JumpBufferTimer"


func enter(_msg := {}) -> void:
	pass

func physics_update(delta: float) -> void:
	var jump := Input.is_action_just_pressed("jump")
	
	if !coyote_timer.is_stopped() and jump:
		state_machine.transition_to("Jump")
		$"../Jump".coyote_jump = true
	elif jump and jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()

	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += Param.GRAVITY_ON_FALL * delta
	owner.move_and_slide()

	if owner.is_on_floor() and is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
	elif owner.is_on_floor():
		state_machine.transition_to("Walk")
	
	if Input.is_action_just_pressed("attack") and Input.is_action_pressed("down"):
		state_machine.transition_to("Execute")
	elif Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
