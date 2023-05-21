extends State

@onready var jump_buffer_timer := $"../../JumpBufferTimer"
@onready var coyote_timer := $"../../CoyoteTimer"

func enter(_msg := {}) -> void:

	owner.execute_disabled = false
	$"../../BoosterPivot".visible = false


func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
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
	
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("down"):
		owner.position.y += 1
