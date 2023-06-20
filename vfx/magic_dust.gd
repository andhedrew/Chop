extends GPUParticles2D

func _ready():
	set_process(true)
	z_index = SortLayer.IN_FRONT
	restart()
	emitting = true
	SoundPlayer.play_sound("poof")

func _process(_delta):
	if not emitting:
		await get_tree().create_timer(5.0).timeout
		queue_free()
