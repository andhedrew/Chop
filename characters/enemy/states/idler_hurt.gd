extends EnemyHurt

func physics_update(delta: float) -> void:
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	await get_tree().create_timer(0.8).timeout
	state_machine.transition_to("Idle")
