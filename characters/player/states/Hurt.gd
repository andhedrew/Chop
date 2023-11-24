extends State

var hitbox_position : Vector2
var hurt_timer: SceneTreeTimer

func enter(_msg := {}) -> void:
	# owner.collision_mask |= (1 << 7)
	owner.animation_player.play("hurt")
	owner.effects_player.play("fx/take_damage")
	SoundPlayer.play_sound("player_voice_oof")
	owner.velocity = owner.knockback
	hurt_timer = get_tree().create_timer(0.3)
	hurt_timer.timeout.connect(_hurt_timer_done)
	state_machine.invulnerable_timer = 1.3
	$"../../BrickBasher".set_deferred("monitoring", false)
	$"../../BrickBasher".set_deferred("monitorable", false)
	

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	if owner.in_water:
		owner.velocity.y += Param.WATER_GRAVITY * delta
	else:
		owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()


func exit() -> void:
	pass


func _hurt_timer_done() -> void:
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Fall")
