extends Label

@export var bar_to_track: TextureProgressBar

func _process(delta):
	text = str( bar_to_track.value )
	
