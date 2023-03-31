extends GPUParticles2D

func _ready():
	z_index = SortLayer.FOREGROUND


func _process(_delta):
	if !emitting:
		queue_free()
