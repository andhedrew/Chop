extends Enemy

func _take_damage(_hitbox) -> void:
	$StateMachine/Idle.take_damage()
