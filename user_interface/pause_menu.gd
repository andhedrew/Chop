extends Control

@onready var main_page := $Main
@onready var settings_page := $Settings

var _is_paused: bool = false

func _ready():
	$Main/Resume.pressed.connect(_on_resume_pressed)
	$Main/Quit.pressed.connect(_on_quit_pressed)
	$Main/Settings.pressed.connect(_on_settings_pressed)
	$Settings/Back.pressed.connect(_on_back_pressed)

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
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
	# Hide main page
	main_page.hide()
	# Show settings page
	settings_page.show()
	# Keep the paused state
	set_paused(true)

func _on_quit_pressed():
	print("quit")
	get_tree().quit()


func _on_back_pressed():
	main_page.show()
	settings_page.hide()
