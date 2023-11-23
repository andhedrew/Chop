extends State

@onready var coyote_timer := $"../../CoyoteTimer"
@onready var jump_buffer_timer := $"../../JumpBufferTimer"


func enter(_msg := {}) -> void:
	GameEvents.player_falling.emit(true)
	await get_tree().create_timer(1.0).timeout
	$"../../BrickBasher".monitoring = false
	$"../../BrickBasher".monitorable = false

func physics_update(delta: float) -> void:
	var jump := Input.is_action_pressed("jump")
	var just_jumped := Input.is_action_just_pressed("jump")
	
	
	if jump and owner.in_water:
		GameEvents.new_vfx.emit("res://vfx/bubble_burst.tscn", owner.global_position)
		owner.velocity.y = owner.jump_height
		state_machine.transition_to("Jump")
	
	if !coyote_timer.is_stopped() and just_jumped:
		state_machine.transition_to("Jump")
		$"../Jump".coyote_jump = true
	elif just_jumped and jump_buffer_timer.is_stopped():
		jump_buffer_timer.start()
	
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)

	if owner.in_water:
		owner.velocity.y += Param.WATER_GRAVITY_ON_FALL * delta
	else:
		owner.velocity.y += Param.GRAVITY_ON_FALL * delta
	owner.move_and_slide()

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


func exit() -> void:
	GameEvents.player_falling.emit(false)

