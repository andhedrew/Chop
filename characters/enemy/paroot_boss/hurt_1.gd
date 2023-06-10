extends EnemyHurt

func enter(msg := {}) -> void:
	super.enter()
	owner.animation_player.play("hurt_1")



func update(delta: float) -> void:
	if state_machine.state_timer > 0.5:
		state_machine.transition_to("Charge")
	
