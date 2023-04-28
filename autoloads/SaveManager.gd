extends Control

const SAVE_PATH := "user://save-data-captain-picard.json"


var data := {}

func _ready() -> void:
	
	if not FileAccess.file_exists(SAVE_PATH):
		setup_json()
	load_json()


func setup_json() -> void:
	var save_data := {
		"level" : "res://levels_and_level_objects/level_scenes/city_level_1.tscn",
		"map_pos" : 0.0,
		"health" : 3,
		"money" : 0,
		"bag_size" : 15,
		"booster_upgrade" : false,
		"booster_charges" : 3,
		"syphon_upgrade" : false,
		"bbq_upgrade" : false,
	}
	var json_data := JSON.stringify(save_data)
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file_access.store_line(json_data)
	file_access.close()


func load_json() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var json_data := file_access.get_line()
	file_access.close()
	var saved_data: Dictionary = JSON.parse_string(json_data)
	data = saved_data


func save_item(key, new_value) -> void:
	data[key] = new_value
	var json_data := JSON.stringify(data)
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file_access.store_line(json_data)
	file_access.close()


func load_item(key):
	if data.has(key):
		return data[key]
	else:
		return null
