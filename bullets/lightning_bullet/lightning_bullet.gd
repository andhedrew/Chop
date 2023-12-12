extends Bullet

func _physics_process(delta):
	var motion : Vector2 = transform.x * speed * delta
	if !triggered_destroy:
		position += motion
	travelled_distance += speed * delta
	if travelled_distance > max_range and not triggered_destroy:
		_destroy()
		triggered_destroy = true
