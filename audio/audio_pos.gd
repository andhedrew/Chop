extends AudioStreamPlayer2D

func _ready():
	self.finished.connect(_on_Audio_finished)
	GameEvents.restarted_level.connect(_on_Audio_finished)


func _on_Audio_finished():
	queue_free()
