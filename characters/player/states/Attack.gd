extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"

func enter(_msg := {}) -> void:
	GameEvents.player_attacked.emit()
	var bullet = preload("res://bullets/slash_bullet/slash_bullet.tscn").instantiate()
	owner.add_child(bullet)
	var transform = $"../../Pivot/BulletSpawn".global_transform
	var fire_range := 10
	var speed := 150
	var spread := 0
	var rotation := 0
	if owner.looking == Enums.Looking.UP:
		rotation = 270
	elif owner.facing == Enums.Facing.LEFT:
		rotation = 180
	bullet.setup(transform, fire_range, speed, rotation, spread)
	SoundPlayer.play_sound("swoosh")


func physics_update(delta: float) -> void:
	if owner.is_on_floor():
		owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
		
		if Input.is_action_pressed("jump"):
			state_machine.transition_to("Jump")
	else:
		var input_direction_x: float = Input.get_axis("left", "right")
		owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	

		
	await animation_player.animation_finished
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	else: 
		state_machine.transition_to("Fall")
	
	
	if Input.is_action_just_pressed("dash"):
		state_machine.transition_to("Dash")


