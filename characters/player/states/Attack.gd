extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"
var slicing_a_block := false


func _ready() -> void:
	GameEvents.player_hit_enemy.connect(_on_hitting_enemy)
	$"../../BrickBasher".set_deferred("monitoring", false)
	$"../../BrickBasher".set_deferred("monitorable", false)



func enter(_msg := {}) -> void:
	if owner.attack_animation_index == 0:
		owner.attack_animation_index = 1
	else:
		owner.attack_animation_index = 0
	
	if owner.in_water:
		GameEvents.new_vfx.emit("res://vfx/bubbles.tscn", owner.global_position)
	
	var bullet = owner.bullet.instantiate()
	owner.add_child(bullet)
	var transform = $"../../Pivot/BulletSpawn".global_transform
	var fire_range = owner.bullet_range
	var speed = owner.bullet_speed
	var spread = owner.bullet_spread
	var rotation := 0
	if owner.looking == Enums.Looking.UP:
		rotation = 270
	elif owner.looking == Enums.Looking.DOWN:
		rotation = 90
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
	
	await get_tree().create_timer(0.05).timeout
	
	if owner.bullet_hit_breakable:
		var boost_speed := 33
		slicing_a_block = true
		owner.velocity.y = lerp(owner.velocity.y,0.0, 0.8)
		
		if owner.looking != Enums.Looking.UP and owner.looking != Enums.Looking.DOWN:
			if owner.facing == Enums.Facing.LEFT:
				owner.velocity.x = -knockback*boost_speed
			elif owner.facing == Enums.Facing.RIGHT:
				owner.velocity.x = knockback*boost_speed
		elif owner.looking != Enums.Looking.DOWN:
			owner.velocity.x = lerp(owner.velocity.x,0.0, 0.1)
			owner.velocity.y = -knockback*boost_speed
		else: #Player is looking down
			owner.velocity.x = lerp(owner.velocity.x,0.0, 0.1)
			owner.velocity.y = knockback*boost_speed
			
	else:
		slicing_a_block = false


	if slicing_a_block:
		var grid_size = 16
		var player_pos = owner.position
		player_pos.x = round(player_pos.x / grid_size) * grid_size
		player_pos.y = round(player_pos.y / grid_size) * grid_size
		owner.position = player_pos
	
	owner.bullet_hit_breakable = false



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
	
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")
	
	if Input.is_action_just_pressed("execute"):
		state_machine.transition_to("Execute")

func _on_hitting_enemy(_enemy) -> void:
	if owner.looking == Enums.Looking.DOWN:
		var knockback = owner.attack_backward_force
		if owner.in_water:
			knockback *= 1.1
		owner.velocity.y = -knockback*15

		
