extends EnemyHurt

func enter(msg := {}) -> void:
	
	owner.animation_player.play("hurt_1")
	owner.effects_player.play("take_damage")
	
	owner.health -= 1
	if owner.health == 3:
		state_machine.phase = 2
		state_machine.transition_to("Transition")

func update(delta: float) -> void:
	if state_machine.state_timer > 0.7:
		state_machine.transition_to("Charge")
	
