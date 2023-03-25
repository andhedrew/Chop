extends State


var dash_time := 0.5
var dash_timer := 0
var dash_direction := Vector2.ZERO
var dash_length := 350

func physics_update(delta: float) -> void:
	if Input.is_action_pressed("dash"):
		dash_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
		owner.velocity = dash_direction * dash_length
		dash_timer = dash_time
	elif dash_timer > 0 and Input.is_action_pressed("dash"):
		owner.velocity = dash_direction * dash_length
		dash_timer -= delta
	elif owner.is_on_floor():
		state_machine.transition_to("Idle")
	else: 
		state_machine.transition_to("Fall")
		
