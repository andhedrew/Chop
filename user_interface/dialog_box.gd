extends Control

var dialog := [
	"He's hungry.",
	"Better get hunting. RIGHT NOW GET GOING NOW NOW NOW NOW NOW",
	"X to attack",
]

var header := [
	"test",
	"testing",
	"123",
]
var dialog_index = 0
var finished = false
@onready var label := $MarginContainer/VBoxContainer/Label
@onready var label_header := $MarginContainer/VBoxContainer/Label2
signal is_finished

func _ready():
	load_dialog()
	z_index = SortLayer.HUD


func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and finished:
		load_dialog()


func load_dialog():
	visible = false
	GameEvents.cutscene_started.emit()
	GameEvents.dialogue_started.emit()
	if dialog_index < dialog.size():
		finished = false
		label.text = dialog[dialog_index]
		label_header.text = header[dialog_index]
		label.visible_ratio = 1
		finished = true
	else:
		GameEvents.cutscene_ended.emit()
		GameEvents.dialogue_finished.emit()
		queue_free()
		is_finished.emit()
	
	reset_size()
	set_new_position()
	
	
	dialog_index += 1
	visible = true
	SoundPlayer.play_sound("page")


func _kill() -> void:
	GameEvents.cutscene_ended.emit()
	queue_free()


func set_new_position():
	var camera = get_parent() as Camera2D  # Assuming the parent is a Camera2D
	var camera_position = camera.global_position
	
	var viewport_size = get_viewport().content_scale_size 

	# Define the camera's limits
	var camera_min_x = camera.limit_left + (viewport_size.x * 0.5)
	var camera_max_x = camera.limit_right - (viewport_size.x * 0.5)
	var camera_min_y = camera.limit_top + (viewport_size.y * 0.5)
	var camera_max_y = camera.limit_bottom - (viewport_size.y * 0.5)
	
	# Calculate the position of the Control node based on the camera's position and limits
	var control_position = Vector2(
		clamp(camera_position.x, camera_min_x, camera_max_x),
		clamp(camera_position.y, camera_min_y, camera_max_y)
	)

	# Adjust the position based on the size of the Control node
	control_position.x -= size.x / 2
	control_position.y += 115 - size.y / 2

	# Set the position of the Control node
	global_position = control_position

