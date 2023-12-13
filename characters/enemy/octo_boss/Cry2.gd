extends State

signal cry_left
signal cry_right

func enter(_msg := {}) -> void:

	self.cry_left.emit()
	self.cry_right.emit()
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
