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
	_load_control_mappings()
	_create_action_list()


func _load_control_mappings():
	var saved_controls = SaveManager.load_item("controls")

	if saved_controls == null or saved_controls.size() < 1:
		print("No saved controls or failed to load controls.")
		return  
	for event in saved_controls:
		var action_name = saved_controls[event]
		_map_key_to_action(event, action_name)



func _map_key_to_action(key, action_name):
	InputMap.action_erase_events(action_name)
	var new_event := InputEventKey.new()
	var key_code = int(key)
	new_event.set_keycode(key_code)
	#new_event.pressed = true
	print("action:", action_name)
	print("event", new_event)
	print(new_event.get_keycode())
	InputMap.action_add_event(action_name, new_event)




func _create_action_list():
	print("building pause menu")
	InputMap.load_from_project_settings() 
	
	for item in action_list.get_children():
		item.queue_free()
	
	
	for action in input_actions: # for each action that we've chosen
		var button = input_button_scene.instantiate() # create a button scene
		var action_label = button.find_child("LabelAction") # get areference to the action label
		var input_label = button.find_child("LabelInput") # get areference to the input label
		
		action_label.text = input_actions[action] # set the label to the display name in the dictionary
		
		var events = InputMap.action_get_events(action) # Get the matching InputEvent
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)") # Set the input label
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
			print("event", event)
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			var action_name := str(action_to_remap)
			var controls_dict = SaveManager.load_item("controls")
			if controls_dict == null:
				controls_dict = {}  # Initialize it as an empty dictionary if it's null
			var key_identifier = event.get_physical_keycode()
			controls_dict[key_identifier] = action_name
			SaveManager.save_item("controls", controls_dict)  # Save the updated dictionary back

			is_reamapping = false
			action_to_remap = null
			remapping_button = null

			accept_event()


func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	_create_action_list()
