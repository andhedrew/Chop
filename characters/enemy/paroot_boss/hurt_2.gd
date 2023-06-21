extends EnemyHurt

func enter(msg := {}) -> void:
	SoundPlayer.play_sound_positional("paroot_boss", owner.global_position)
	owner.animation_player.play("hurt2")
	owner.effects_player.play("take_damage")
	owner.health -= 1
	state_machine.invulnerable_timer = 1.0


func update(delta: float) -> void:
	if state_machine.state_timer > 0.5:
		state_machine.transition_to("Charge")
