extends State


func enter(_msg := {}) -> void:
	$"../../Pivot/AnimationPlayer".pause()


func update(_delta: float) -> void:
#	owner.velocity.y += Param.GRAVITY_ON_FALL * delta
	owner.velocity.y = lerp(owner.velocity.y, 0.0, Param.FRICTION)
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
