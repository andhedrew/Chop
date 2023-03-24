extends State


func enter(_msg := {}) -> void:
	pass


func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
