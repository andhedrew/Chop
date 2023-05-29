extends State

var hitbox_position : Vector2
var hurt_timer: SceneTreeTimer
func enter(_msg := {}) -> void:
	owner.animation_player.play("hurt")
	owner.effects_player.play("fx/take_damage")
	SoundPlayer.play_sound("player_voice_oof")
	owner.velocity = owner.knockback
	hurt_timer = get_tree().create_timer(0.5)
	hurt_timer.timeout.connect(_hurt_timer_done)
	state_machine.invulnerable_timer = 2.0
	

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	var input_direction_x: float = Input.get_axis("left", "right")
	owner.velocity.x = move_toward(owner.velocity.x, owner.max_speed * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()


func exit() -> void:
	pass


func _hurt_timer_done() -> void:
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Fall")
