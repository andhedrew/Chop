extends State

var speed := 85

func enter(_msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	owner.position.x += speed*delta

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
