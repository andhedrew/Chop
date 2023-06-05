extends Enemy

func _take_damage(hitbox) -> void:
	$StateMachine/Idle.take_damage()
