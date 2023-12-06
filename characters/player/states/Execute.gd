extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"
@onready var camera: Camera2D

var gravity_multiplier := 0.35

func enter(_msg := {}) -> void:
	if !owner.execute_disabled:
		camera = owner.camera
		owner.velocity.y = 0
		await get_tree().create_timer(0.25).timeout
		SoundPlayer.play_sound("player_voice_effort")
		camera.flash_screen(0.01, owner.global_position)
		fire()
		owner.execute_disabled = true
		GameEvents.player_executed.emit()
		if owner.in_water:
			owner.velocity.y = -250
		else:
			owner.velocity.y = -80
		SoundPlayer.play_sound("punch")
		SoundPlayer.play_sound("slash_flesh")
	else:
		state_machine.transition_to("Fall")
	$"../../BrickBasher".set_deferred("monitoring", false)
	$"../../BrickBasher".set_deferred("monitorable", false)


func physics_update(delta: float) -> void:
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, (owner.max_speed*0.25) * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += (Param.GRAVITY_ON_FALL*gravity_multiplier) * delta
	owner.move_and_slide()
	
	if Input.is_action_just_pressed("dash") and owner.has_booster_upgrade:
		state_machine.transition_to("Dash")
		
	
	await animation_player.animation_finished
	
	if state_machine.state.name != "Dash":
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Fall")



func fire() -> void:
	var bullet = owner.execute_bullet.instantiate()
	owner.add_child(bullet)
	var transform = $"../../Pivot/BulletSpawn".global_transform
	var fire_range = owner.execute_range
	var speed = owner.execute_speed
	var spread = owner.execute_spread
	var rotation := 0
	rotation = 90
	bullet.setup(transform, fire_range, speed, rotation, spread)
	Fade.crossfade_prepare(1.0, "Chop")
	Fade.crossfade_execute() 


func exit() -> void:
	if owner.buffer_execute == false:
		owner.execute_disabled = true
	else:
		owner.execute_disabled = false
		owner.buffer_execute = false
		
