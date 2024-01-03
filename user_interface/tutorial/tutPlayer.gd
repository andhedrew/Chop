extends AnimationPlayer

var triggered := true

# Called when the node enters the scene tree for the first time.
func _ready():
	play("fade_in")
	GameEvents.tut3.connect(tut_done)

	GameEvents.dialogue_started.connect(on_cutscene_start)
	GameEvents.dialogue_finished.connect(on_cutscene_end)


func on_cutscene_start():
	play_backwards("fade_in")


func on_cutscene_end():
	play("fade_in")


func tut_done():
	triggered = true
