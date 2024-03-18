extends Control


var music: AudioStreamPlayer
var ambient: AudioStreamPlayer
@onready var main_page := $Main
@onready var settings_page := $Settings
@onready var current_page := main_page
@onready var input_menu := $InputSettings


func _ready():
	var saved = SaveManager.load_item("saved_data")
	if saved == true:
		$Main/v/Button3.disabled = false
	else:
		$Main/v/Button3.disabled = true
	$Main/v/Button.pressed.connect(_new_game)
	$Main/v/Button3.pressed.connect(_continue_game)
	$Main/v/Button2.pressed.connect(_end_game)
	$Main/v/SettingsButton.pressed.connect(_on_settings_pressed)
	$Settings/Back.pressed.connect(_on_back_pressed)
	music = SoundPlayer.play_music("City1")
	ambient = SoundPlayer.play_music("rain")
	$"Settings/Remap Controls".pressed.connect(_on_remap_button_pressed)
	$InputSettings/Back.pressed.connect(_on_back_pressed)


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if current_page == settings_page or current_page == input_menu:
			_on_back_pressed()
		else:
			_on_back_pressed()

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


func _on_settings_pressed():
	main_page.hide()
	settings_page.show()


func _on_back_pressed():
	if current_page == input_menu:
		input_menu.hide()
		settings_page.show()
		current_page = settings_page
	else:
		current_page = main_page
		main_page.show()
		settings_page.hide()


func _on_remap_button_pressed():
	input_menu.show()
	settings_page.hide()
	current_page = input_menu
	
