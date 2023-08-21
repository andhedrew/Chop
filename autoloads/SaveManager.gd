extends Control

const SAVE_PATH := "user://save-data-captain-picard.json"


var data := {}

func _ready() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		setup_json()
	load_json()
	GameEvents.SaveDataReady.emit()


func setup_json() -> void:
	var save_data := {
		"level" : "res://levels_and_level_objects/level_scenes/city_level_1.tscn",
		"map_pos" : 0.0,
		"health" : 4,
		"money" : 0,
		"bag_size" : 10,
		"booster_upgrade" : false,
		"booster_charges" : 2,
		"syphon_upgrade" : false,
		"bbq_upgrade" : false,
		"brick_stomach" : 0.0,
		"plant_stomach" : 0.0,
		"meat_stomach" : 0.0,
		"lb_position" : Vector2.ZERO,
		"tutorial" : {
			"enemy_execute_prompted": true,
			"adding_food_prompted": true,
			"done_feeding_prompted": true,
			"coin_prompted": true,
			"plant_bar_prompted": true,
			"start_of_level_prompted": true,
			"full_bag_prompted": true,
		"saved_data": false
			
				}
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
	data["saved_data"] = true
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


func reset_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		OS.move_to_trash(ProjectSettings.globalize_path(SAVE_PATH))
		setup_json()
		print_debug("Save Data Reset")
