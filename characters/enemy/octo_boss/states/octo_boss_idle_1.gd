extends State


func enter(_msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	if state_machine.state_timer > 1:
		state_machine.transition_to("Move")

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
