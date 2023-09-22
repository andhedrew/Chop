extends Marker2D

func _ready():
	$Timer.timeout.connect(_on_timeout)
	$Timer.start()
	

func _on_timeout() -> void:
	var pos : Vector2 = global_position/16
	print_debug(str(pos))
	GameEvents.replace_tile.emit(pos)
	queue_free()
