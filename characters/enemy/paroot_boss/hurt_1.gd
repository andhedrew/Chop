extends EnemyHurt

var transitioning := false

func enter(_msg := {}) -> void:
	SoundPlayer.play_sound_positional("paroot_boss", owner.global_position)
	owner.animation_player.play("hurt_1")
	owner.effects_player.play("take_damage")
	
	owner.health -= 1
	if owner.health <= 6:
		transitioning = true
		
		state_machine.transition_to("Transition")
	
	state_machine.invulnerable_timer = 1.0

func update(_delta: float) -> void:
	if state_machine.state_timer > 0.5 and !transitioning:
		state_machine.transition_to("Charge")
	
