extends State

@onready var jump_buffer_timer := $"../../JumpBufferTimer"
@onready var coyote_timer := $"../../CoyoteTimer"

func enter(_msg := {}) -> void:
	pass


func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	# If you have platforms that break when standing on them, you need that check for 
	# the character to fall.
	if not owner.is_on_floor():
		coyote_timer.start()
		state_machine.transition_to("Fall")
		return


	if Input.is_action_just_pressed("jump") or !jump_buffer_timer.is_stopped():
		# As we'll only have one air state for both jump and fall, we use the `msg` dictionary 
		# to tell the next state that we want to jump.
		state_machine.transition_to("Jump")
		jump_buffer_timer.stop()
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		state_machine.transition_to("Walk")

	if Input.is_action_just_pressed("attack"):
		state_machine.transition_to("Attack")
