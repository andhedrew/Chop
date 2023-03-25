extends EnemyHurt

func physics_update(delta: float) -> void:
	await get_tree().create_timer(0.8).timeout
	state_machine.transition_to("Move")
