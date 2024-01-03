extends AnimatedSprite2D


var triggered := false
var cutscene_running := false
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.tut3.connect(tut_done)
	visible = false
	GameEvents.cutscene_started.connect(on_cutscene_start)
	GameEvents.cutscene_ended.connect(on_cutscene_end)


func _process(delta):
	if triggered and !cutscene_running:
		visible = true
	else:
		visible = false

func on_cutscene_start():
	cutscene_running = true


func on_cutscene_end():
	cutscene_running = false

func tut_done():
	triggered = true
