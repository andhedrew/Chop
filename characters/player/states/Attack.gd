extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"

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
			knockback *= 1.2
		if owner.facing == Enums.Facing.LEFT:
			owner.velocity.x += knockback
		else:
			owner.velocity.x -= knockback
		
		if owner.looking != Enums.Looking.UP:
			owner.velocity.y -= owner.attack_upward_force
		


func physics_update(delta: float) -> void:
	if owner.weapon == Enums.Weapon.FAST:
		if Input.is_action_just_pressed("attack"):
			state_machine.transition_to("Attack")
	
	if owner.is_on_floor():
		if Input.is_action_pressed("jump"):
			state_machine.transition_to("Jump")
#	
	if owner.in_water:
		owner.velocity.y += Param.WATER_GRAVITY * delta
	else:
		owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	

		
	await animation_player.animation_finished
	if state_machine.state_timer > owner.attack_delay and owner.state != "Cutscene":
		state_machine.transition_to("Idle")
	elif owner.state != "Cutscene": 
		state_machine.transition_to("Fall")
	
	
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")


