extends State

var dash_direction := Vector2.ZERO
var dash_length := 450

func enter(_msg := {}) -> void:
	owner.execute_disabled = false
	$"../../Pivot/Weapon".visible = false
	

func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("dash") and owner.torch_charges > 0:
		dash_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")).normalized()
#		dash_direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()
		owner.velocity = -dash_direction * dash_length

	elif Input.is_action_pressed("dash") and owner.torch_charges > 0:
		owner.velocity = dash_direction * dash_length
	elif owner.is_on_floor():
		state_machine.transition_to("Idle")
	else: 
		state_machine.transition_to("Fall")

func exit():
	if owner.torch_charges > 0:
		owner.torch_charges -= 1
		GameEvents.charge_amount_changed.emit(owner.torch_charges, owner.max_torch_charges)
		var bullet = preload("res://bullets/fire_bullet/fire_bullet.tscn").instantiate()
		owner.add_child(bullet)
		var transform = $"../../Pivot/BulletSpawn".global_transform
		var fire_range := 50
		var speed := 120
		var spread := 0
		var rotation := rad_to_deg(atan2(dash_direction.y, dash_direction.x))

		bullet.setup(transform, fire_range, speed, rotation, spread)
	$"../../Pivot/Weapon".visible = true
