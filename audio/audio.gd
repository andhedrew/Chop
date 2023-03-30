extends AudioStreamPlayer

func _ready():
	self.finished.connect(_on_Audio_finished)


func _on_Audio_finished():
	queue_free()
