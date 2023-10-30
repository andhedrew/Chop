extends State

func enter(_msg := {}) -> void:
	owner.animation_player.play("fall")


func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:

	owner.velocity.y += Param.GRAVITY * delta
	owner.velocity.y = min(owner.velocity.y, 200)
	owner.move_and_slide()
	
	if owner.is_on_floor():
		if state_machine.has_node("Idle"):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")

func exit() -> void:
	pass
