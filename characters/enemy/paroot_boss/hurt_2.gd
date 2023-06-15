extends EnemyHurt

func enter(msg := {}) -> void:
	owner.effects_player.play("take_damage")
	owner.animation_player.play("hurt2")
	owner.health -= 1



func update(delta: float) -> void:
	if state_machine.state_timer > 0.9:
		state_machine.transition_to("Charge")
	
