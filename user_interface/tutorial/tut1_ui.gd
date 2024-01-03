extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.cutscene_started.connect(on_cutscene_start)
	GameEvents.cutscene_ended.connect(on_cutscene_end)


func on_cutscene_start():
	visible = false


func on_cutscene_end():
	visible = true
