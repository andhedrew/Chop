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
	#GameEvents.dialogue_finished.connect(load_dialog)

func _process(delta):
	$NinePatchRect/Sprite2D.visible = finished
	if Input.is_action_just_pressed("ui_accept") and finished:
		load_dialog()


func load_dialog():
	SoundPlayer.play_sound("page")
	GameEvents.cutscene_started.emit()
	GameEvents.dialogue_started.emit()
	if dialog_index < dialog.size():
		finished = false
		label.text = dialog[dialog_index]
		label_header.text = header[dialog_index]
		label.visible_ratio = 1
		await get_tree().create_timer(0.5).timeout
		finished = true
	else:
		GameEvents.cutscene_ended.emit()
		GameEvents.dialogue_finished.emit()
		queue_free()
		is_finished.emit()
	dialog_index += 1
	



func _kill() -> void:
	GameEvents.cutscene_ended.emit()
	queue_free()

