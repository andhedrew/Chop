extends GPUParticles2D

func _ready():
	set_process(true)

func _process(delta):
	if not emitting:
		queue_free()
