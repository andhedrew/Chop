extends Area2D

var replacing_tile := false
var wait_time := 0.4
func _ready():
	$Timer.timeout.connect(_on_timeout)
	$Timer.wait_time += randf_range(-wait_time, wait_time)
	$Timer.start()

func _process(_delta):
	if replacing_tile and not is_colliding():
		var pos : Vector2 = global_position/16
		GameEvents.replace_tile.emit(pos)
		queue_free()

func _on_timeout() -> void:
	replacing_tile = true

func is_colliding() -> bool:
	for body in get_overlapping_bodies():
		if body is Player:
			return true
	return false
