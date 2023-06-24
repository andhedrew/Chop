extends Control

var dialog := [
	"He's hungry.",
	"Better get hunting. RIGHT NOW GET GOING NOW NOW NOW NOW NOW",
	"X to attack",
]

var dialog_index = 0
var finished = false
@onready var label := $VBoxContainer/Label
signal is_finished

func _ready():
	load_dialog()
	#GameEvents.dialogue_finished.connect(load_dialog)

func _process(delta):
	if Input.is_action_just_pressed("debug_1"):
		_kill()
	$VBoxContainer/Label/MarginContainer/NinePatchRect/Sprite2D.visible = finished
	if Input.is_action_just_pressed("ui_accept") and finished:
		load_dialog()

#func load_dialog():
#	GameEvents.cutscene_started.emit()
#	GameEvents.dialogue_started.emit()
#	if dialog_index < dialog.size():
#		finished = false
#		label.text = dialog[dialog_index]
#		label.visible_ratio = 0
#		var character_count =  dialog[dialog_index].length()
#		var tween = create_tween()
#		tween.tween_property(label, "visible_ratio", 1, .03 * character_count)
#		tween.finished.connect(_on_tween_finished)
#	else:
#		GameEvents.cutscene_ended.emit()
#		GameEvents.dialogue_finished.emit()
#		queue_free()
#		is_finished.emit()
#	dialog_index += 1

func load_dialog():
	GameEvents.cutscene_started.emit()
	GameEvents.dialogue_started.emit()
	if dialog_index < dialog.size():
		finished = false
		label.text = dialog[dialog_index]
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

