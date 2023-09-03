extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"
var slicing_a_block := false

func enter(_msg := {}) -> void:
		var bullet = owner.bullet.instantiate()
		owner.add_child(bullet)
		var transform = $"../../Pivot/BulletSpawn".global_transform
		var fire_range = owner.bullet_range
		var speed = owner.bullet_speed
		var spread = owner.bullet_spread
		var rotation := 0
		if owner.looking == Enums.Looking.UP:
			rotation = 270
		elif owner.facing == Enums.Facing.LEFT:
			rotation = 180
		bullet.setup(transform, fire_range, speed, rotation, spread)
		SoundPlayer.play_sound("swoosh")
		
		var knockback = owner.attack_backward_force
		if owner.in_water:
			knockback *= 1.1
		if owner.facing == Enums.Facing.LEFT:
			owner.velocity.x += knockback
		else:
			owner.velocity.x -= knockback
		
		if owner.block_detector.is_colliding() or owner.block_detector2.is_colliding():
			slicing_a_block = true
			owner.collision_mask |= (1 << 7)
			owner.velocity.y = 0
			await get_tree().create_timer(0.05).timeout
			var boost_speed := 30
			
			if owner.looking != Enums.Looking.UP:
				if owner.facing == Enums.Facing.LEFT:
					owner.velocity.x = -knockback*boost_speed
				elif owner.facing == Enums.Facing.RIGHT:
					owner.velocity.x = knockback*boost_speed
			else:
				owner.velocity.x = 0
				owner.velocity.y = -knockback*boost_speed
		else:
			slicing_a_block = false
		if slicing_a_block:
			var grid_size = 16
			var player_pos = owner.position
			player_pos.x = round(player_pos.x / grid_size) * grid_size
			player_pos.y = round(player_pos.y / grid_size) * grid_size
			owner.position = player_pos



func physics_update(delta: float) -> void:
	if owner.weapon == Enums.Weapon.FAST or slicing_a_block:
		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack")
	
	if owner.is_on_floor():
		if Input.is_action_pressed("jump"):
			state_machine.transition_to("Jump")
#	
	if !slicing_a_block:
		if owner.in_water:
			owner.velocity.y += Param.WATER_GRAVITY * delta
		else:
			owner.velocity.y += Param.GRAVITY * delta

	owner.move_and_slide()
		
	if state_machine.state_timer > owner.attack_delay and owner.state != "Cutscene":
		state_machine.transition_to("Idle")
#	elif owner.state != "Cutscene": 
#		state_machine.transition_to("Fall")
	
	
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")

