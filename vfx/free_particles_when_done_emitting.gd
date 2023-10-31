extends GPUParticles2D


func _ready():
	set_process(true)
	z_index = SortLayer.FOREGROUND
	restart()
	emitting = true
	SoundPlayer.play_sound("dust")

func _process(_delta):
	if not emitting:
		await get_tree().create_timer(1.0).timeout
		queue_free()
