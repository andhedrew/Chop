extends EnemyHurt

func enter(msg := {}) -> void:
	super.enter()
	hitbox_position = msg["position"]
	owner.velocity.x = owner.global_position.x - (hitbox_position.x)
	if sign(owner.velocity.x) == 1:
		owner.set_facing(Enums.Facing.LEFT)
	elif sign(owner.velocity.x) == -1:
		owner.set_facing(Enums.Facing.RIGHT)


func physics_update(delta: float) -> void:
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()

	if state_machine.state_timer >= 0.15:
		state_machine.transition_to("Idle")
	
