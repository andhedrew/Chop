extends GPUParticles2D

func _ready():
	set_process(true)

func _process(_delta):
	if not emitting:
		queue_free()
