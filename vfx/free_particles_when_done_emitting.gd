extends GPUParticles2D

func _ready():
	set_process(true)

func _process(_delta):
	if not emitting:
		await get_tree().create_timer(5.0).timeout
		queue_free()
