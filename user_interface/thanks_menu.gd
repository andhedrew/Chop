extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button2.pressed.connect(_end_game)
	$Button3.pressed.connect(_open_link)

func _end_game() -> void:
	get_tree().quit()
	print_debug("end_game")


func _open_link() -> void:
	OS.shell_open("https://discord.gg/QurkenT")
