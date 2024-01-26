extends Control

@onready var input_button_scene := preload("res://user_interface/input_button.tscn")
@onready var action_list := $PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/ActionList

var is_reamapping := false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"left" : "Left",
	"right" : "Right",
	"up" : "Up",
	"down" : "Down",
	"attack" : "Attack",
	"jump" : "Jump",
	"execute" : "CHOP",
	"dash" : "Booster",
}

func _ready():
	_create_action_list()


func _create_action_list():
	InputMap.load_from_project_settings()
	for item in action_list.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	if !is_reamapping:
		is_reamapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."


func _input(event):
	if is_reamapping:
		if (
			event is InputEventKey or 
			(event is InputEventMouseButton and event.pressed)
		):
			
			if event is InputEventMouseButton and event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_reamapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()


func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	_create_action_list()
