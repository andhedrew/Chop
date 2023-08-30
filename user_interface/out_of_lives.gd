extends Control


var music: AudioStreamPlayer
var ambient: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var saved = SaveManager.load_item("saved_data")
	if saved == true:
		$Button3.disabled = false
	$Button3.pressed.connect(_continue_game)
	$Button2.pressed.connect(_go_to_menu)
	music = SoundPlayer.play_music("violins")
	ambient = SoundPlayer.play_music("rain")


func _continue_game() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file("res://user_interface/lives_restock.tscn")
	Fade.crossfade_execute() 


func _go_to_menu() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file("res://user_interface/main_menu.tscn")
	Fade.crossfade_execute() 


func _exit_tree():
	print_debug("exited")
	music.playing = false
	ambient.playing = false
	
