extends State

func enter(_msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	var target = owner.player_position.x
	owner.position.x = lerp(owner.position.x, target, 0.02)



func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
