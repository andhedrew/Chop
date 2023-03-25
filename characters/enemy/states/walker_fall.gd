extends State

func enter(_msg := {}) -> void:
	owner.animation_player.play("fall")


func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:

	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	
	if owner.is_on_floor():
		state_machine.transition_to("Idle")

func exit() -> void:
	pass
