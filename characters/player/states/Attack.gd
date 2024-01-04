extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"
var slicing_a_block := false
var boost_speed := 0.0
var attack_delay := 0.3
var default_attack_delay := attack_delay

func _ready() -> void:
	attack_delay = default_attack_delay
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
	
	
	
	if owner.bullet_hit_breakable:
		attack_delay = 0.6
		owner.velocity = Vector2.ZERO

		var grid_size = 16
		var player_pos = owner.position
		player_pos.x = round(player_pos.x / grid_size) * grid_size
		player_pos.y = round(player_pos.y / grid_size) * grid_size
		owner.position = player_pos




func physics_update(delta: float) -> void:
	
	if owner.bullet_hit_breakable:
		var speed_calc = 100.0 * owner.bullet_hit_breakable_count
		speed_calc = max(speed_calc, 200.0)
		
		if owner.looking == Enums.Looking.DOWN:
			speed_calc = max(speed_calc, 180.0)
		elif owner.looking ==  Enums.Looking.UP:
			speed_calc = max(speed_calc, 200.0)
			
		boost_speed = lerp(boost_speed, speed_calc, 0.4)
		slicing_a_block = true

		# Directly set the velocity
		if owner.looking != Enums.Looking.UP and owner.looking != Enums.Looking.DOWN:
			if owner.facing == Enums.Facing.LEFT:
				owner.velocity.x = -boost_speed
				owner.velocity.y = 0.0
			elif owner.facing == Enums.Facing.RIGHT:
				owner.velocity.x = boost_speed
				owner.velocity.y = 0.0
		elif owner.looking != Enums.Looking.DOWN:
			owner.velocity.y = -boost_speed
			owner.velocity.x = 0.0
		else: # Player is looking down
			owner.velocity.y = boost_speed
			owner.velocity.x = 0.0
	else:
		slicing_a_block = false

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
		
	if state_machine.state_timer > attack_delay and owner.state != "Cutscene":
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


func exit() -> void:
	owner.bullet_hit_breakable = false
