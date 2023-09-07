extends EnemyHurt

func enter(msg := {}) -> void:
	super.enter()
	hitbox_position = msg["position"]
	owner.velocity.x = owner.global_position.x - (hitbox_position.x)
	if sign(owner.velocity.x) == 1:
		owner.set_facing(Enums.Facing.LEFT, false)
	elif sign(owner.velocity.x) == -1:
		owner.set_facing(Enums.Facing.RIGHT, false)

	owner.velocity.y = -90


func physics_update(delta: float) -> void:
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()

	if owner.is_on_floor():
		if state_machine.has_node("Idle"):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
