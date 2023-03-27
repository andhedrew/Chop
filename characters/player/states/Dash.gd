extends State


var dash_time := 0.5
var dash_timer := 0
var dash_direction := Vector2.ZERO
var dash_length := 350

func enter(_msg := {}) -> void:
	$"../../Pivot/Weapon".visible = false

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
		

func exit():
	$"../../Pivot/Weapon".visible = true
	var bullet = preload("res://bullets/fire_bullet/fire_bullet.tscn").instantiate()
	owner.add_child(bullet)
	var transform = $"../../Pivot/BulletSpawn".global_transform
	var fire_range := 50
	var speed := 120
	var spread := 0
	var rotation := rad_to_deg(atan2(-dash_direction.y, -dash_direction.x))
	bullet.setup(transform, fire_range, speed, rotation, spread)
