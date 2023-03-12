extends State

func enter(_msg := {}) -> void:
	var bullet = preload("res://bullets/slash_bullet.tscn").instantiate()
	add_child(bullet)
	var transform := 0
	var fire_range := 50
	var speed := 50
	var spread := 0
	var rotation := 180
	bullet.setup(transform, fire_range, speed, rotation, spread)


func physics_update(delta: float) -> void:
	pass
