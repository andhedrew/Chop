extends Control


var music: AudioStreamPlayer
var ambient: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var saved = SaveManager.load_item("saved_data")
	if saved == true:
		$Button3.disabled = false
	else:
		$Button3.disabled = true
	$Button.pressed.connect(_new_game)
	$Button3.pressed.connect(_continue_game)
	$Button2.pressed.connect(_end_game)
	music = SoundPlayer.play_music("City1")
	ambient = SoundPlayer.play_music("rain")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _new_game() -> void:
	SaveManager.reset_save()
	SaveManager.setup_json()
	SaveManager.load_json()
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file("res://levels_and_level_objects/level_scenes/world_1_levels/1-1.tscn")
	Fade.crossfade_execute() 
	print_debug("new_game")


func _continue_game() -> void:
	var current_level = SaveManager.load_item("level")
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(current_level)
	Fade.crossfade_execute() 
	print_debug("_continue_game")


func _end_game() -> void:
	get_tree().quit()
	print_debug("end_game")


func _exit_tree():
	print_debug("exited")
	music.playing = false
	ambient.playing = false
	
