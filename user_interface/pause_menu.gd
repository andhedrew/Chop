extends Control

@onready var main_page := $Main
@onready var settings_page := $Settings
@onready var current_page := main_page
@onready var input_menu := $InputSettings


var _is_paused: bool = false
var cutscene_running := false

func _ready():
	$Main/Resume.pressed.connect(_on_resume_pressed)
	$Main/ResetLevel.pressed.connect(_on_reset_pressed)
	$Main/Quit.pressed.connect(_on_quit_pressed)
	$Main/Settings.pressed.connect(_on_settings_pressed)
	$Settings/Back.pressed.connect(_on_back_pressed)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	$"Settings/Remap Controls".pressed.connect(_on_remap_button_pressed)
	$InputSettings/Back.pressed.connect(_on_back_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause") and !cutscene_running:
		if current_page == settings_page or current_page == input_menu:
			_on_back_pressed()
		else:
			_on_back_pressed()
			_is_paused = !_is_paused
			set_paused(_is_paused)

func set_paused(value: bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_pressed():
	_is_paused = false
	set_paused(false)

func _on_settings_pressed():
	current_page = settings_page
	main_page.hide()
	settings_page.show()
	set_paused(true)

func _on_quit_pressed():
	print("quit")
	get_tree().quit()


func _on_back_pressed():
	if current_page == input_menu:
		input_menu.hide()
		settings_page.show()
		current_page = settings_page
	else:
		current_page = main_page
		main_page.show()
		settings_page.hide()


func _on_cutscene_start():
	cutscene_running = true

func _on_cutscene_end():
	cutscene_running = false


func _on_remap_button_pressed():
	input_menu.show()
	settings_page.hide()
	current_page = input_menu
	


func _on_reset_pressed():
	_is_paused = !_is_paused
	set_paused(_is_paused)
	get_tree().reload_current_scene()
