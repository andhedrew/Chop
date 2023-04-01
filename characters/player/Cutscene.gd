extends State


func enter(_msg := {}) -> void:
	pass


func update(delta: float) -> void:
	owner.velocity.y += Param.GRAVITY_ON_FALL * delta
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
