extends Control

const SAVE_PATH := "user://save-data-captain-picard.json"


var data := {}
var controls = null

func _ready() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		setup_json()
	load_json()
	GameEvents.SaveDataReady.emit()


func setup_json() -> void:
	var save_data := {
		"level" : "res://levels_and_level_objects/level_scenes/world_1_levels/1-1.tscn",
		"checkpoint" : "res://levels_and_level_objects/level_scenes/world_1_levels/1-1.tscn",
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
			"enemy_execute_prompted": false,
			"adding_food_prompted": false,
			"done_feeding_prompted": false,
			"coin_prompted": false,
			"plant_bar_prompted": false,
			"start_of_level_prompted": false,
			"full_bag_prompted": false,
			"mush_prompted": false,
		"saved_data": false,
		"lives": 5,
		"score": 0.0,
		"food_score": 0,
		"meat_score": 0,
		"brick_score": 0,
		"checkpoint_reached_this_level" : false,
		"checkpoint_position" : Vector2.ZERO,
		"bag" : [],
		"spider_triggered" : false,
		"wave_triggered" : false,
		}
	}
	if controls:
		save_data["controls"] = controls

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
	if typeof(new_value) == TYPE_VECTOR2:
		data[key] = [new_value.x, new_value.y]  # Convert Vector2 to an array
	else:
		data[key] = new_value
	var json_data := JSON.stringify(data)
	var file_access := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file_access.store_line(json_data)
	file_access.close()


func load_item(key):
	if data.has(key):
		var value = data[key]
		if typeof(value) == TYPE_ARRAY and value.size() == 2 and key == "checkpoint_position":
			print_debug("save value: " + str(value))
			# Ensure the values are converted to floats
			var x = float(value[0])
			var y = float(value[1])
			return Vector2(x, y)  # Reconstruct Vector2
		else:
			return value
	else:
		return null


func reset_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		if data.has("controls"):
			controls = data["controls"]
		else:
			print("failed to find controls")
			controls = null
		OS.move_to_trash(ProjectSettings.globalize_path(SAVE_PATH))
		setup_json()
		print_debug("Save Data Reset")
