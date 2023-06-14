extends EnemyHurt

func enter(msg := {}) -> void:
	owner.effects_player.play("take_damage")
	owner.animation_player.play("hurt_1")
	owner.health -= 1
	if owner.health == 3:
		state_machine.phase = 2
	
	if owner.health <= 0:
		state_machine.transition_to("Die")



func update(delta: float) -> void:
	if state_machine.state_timer > 0.5:
		state_machine.transition_to("Charge")
	
