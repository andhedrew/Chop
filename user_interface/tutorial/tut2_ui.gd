extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.tut2.connect(on_tut2_done)


func on_tut2_done():
	visible = false
