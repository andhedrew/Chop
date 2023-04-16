extends State

var dash_direction := Vector2.ZERO
var dash_length := 450
var state_timer := 0


func enter(_msg := {}) -> void:
	owner.execute_disabled = false



func physics_update(delta: float) -> void:

	if Input.is_action_pressed("dash") and owner.torch_charges > 0:
		dash_direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()
		owner.velocity = -dash_direction * dash_length
	else:
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Fall")
		owner.position.y += 3*delta

func exit():
	if dash_direction == Vector2(0.0,0.0):
		match owner.facing:
			Enums.Facing.LEFT:
				dash_direction = Vector2(1.0, 0.0)
			Enums.Facing.RIGHT:
				dash_direction = Vector2(-1.0, 0.0)
		owner.velocity = -dash_direction * dash_length
		
	if owner.torch_charges > 0:
		SoundPlayer.play_sound("fireball")
#		SoundPlayer.play_sound("rev")
		
		owner.torch_charges -= 1
		GameEvents.charge_amount_changed.emit(owner.torch_charges, owner.max_torch_charges)
		var bullet = preload("res://bullets/fire_bullet/fire_bullet.tscn").instantiate()
		owner.add_child(bullet)
		var transform = $"../../BoosterPivot".global_transform
		var fire_range := 50
		var speed := 120
		var spread := 0
		var rotation := rad_to_deg(atan2(dash_direction.y, dash_direction.x))
		bullet.setup(transform, fire_range, speed, rotation, spread)

		bullet = preload("res://bullets/slice_charge_bullet/slice_charge_bullet.tscn").instantiate()
		owner.add_child(bullet)
		transform = $"../../BoosterPivot".global_transform
		fire_range = 10
		speed = 200
		spread = 0
		rotation = rad_to_deg(atan2(dash_direction.y, dash_direction.x))+180
		bullet.setup(transform, fire_range, speed, rotation, spread)
