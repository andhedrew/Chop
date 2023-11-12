extends RayCast2D

var time_passed: float = 0.0

func _process(delta):
	time_passed += delta
	var new_rotation = sin(time_passed / 3.0 * 2.0 * PI) * 25.0
	rotation = deg_to_rad(new_rotation)
