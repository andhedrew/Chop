extends EnemyHurt

func enter(msg := {}) -> void:
	super.enter()
	owner.velocity.x = owner.global_position.x - (hitbox_position.x)
	hitbox_position = msg[1]
	if sign(owner.velocity.x) == 1:
		owner.set_facing(Enums.Facing.LEFT)
	elif sign(owner.velocity.x) == -1:
		owner.set_facing(Enums.Facing.RIGHT)

	owner.velocity.y = -150


func physics_update(delta: float) -> void:
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()

	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	
