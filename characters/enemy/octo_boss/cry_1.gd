extends State

signal cry_left
signal cry_right

func enter(_msg := {}) -> void:
	if owner.arm_gone["left"] or owner.arm_gone["right"]:
		self.cry_left.emit()
		self.cry_right.emit()
	else:
		if randf() < 0.5:
			self.cry_left.emit()
		else:
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