extends Label

@export var bar_to_track: TextureProgressBar

func _process(_delta):
	var bar_value = round((bar_to_track.value / bar_to_track.max_value) * 100)
	text = str( bar_value ) + "%"
	modulate = Color8(191 + int(bar_value * 64), 191 + int(bar_value * 64), 191 + int(bar_value * 64))
