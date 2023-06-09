extends Label

@export var bar_to_track: TextureProgressBar

func _process(_delta):
	text = str( bar_to_track.value )
	
