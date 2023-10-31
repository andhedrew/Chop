extends State

func enter(_msg := {}) -> void:
	owner.animation_player.play("fall")

func physics_update(delta: float) -> void:
	if owner.is_on_floor():
		if state_machine.has_node("Idle"):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
			
	owner.velocity.x = lerp(owner.velocity.x, 0.0, 0.2)
	owner.velocity.y += Param.GRAVITY * delta
	owner.velocity.y = min(owner.velocity.y, 200)
	owner.move_and_slide()
