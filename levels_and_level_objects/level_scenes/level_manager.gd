class_name LevelManager
extends Node2D

@export var dream_image: Texture
@export var map_position: float
@export_file("*.tscn") var next_level
@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
#	SoundPlayer.play_music("blues")
	GameEvents.evening_ended.connect(_on_evening_ended)
	GameEvents.transition_to_map.connect(_on_transitioning_to_map)
	GameEvents.morning_started.connect(_on_morning_started)
	SaveManager.save_item("level", scene_file_path)
	GameEvents.hunt_started.connect(_on_hunt_started)
	GameEvents.player_died.connect(_restart_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		_restart_level()
	if Input.is_action_just_pressed("reset_save_data"):
		SaveManager.reset_save()
		


func _restart_level() -> void:
	print_debug("restarting")
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	get_tree().reload_current_scene()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	Fade.crossfade_execute() 
	

func _on_evening_ended() -> void:
	var dream := preload("res://levels_and_level_objects/dream/dream.tscn").instantiate()
	dream.get_node("Dream/Sprite2D").texture = dream_image
	add_child(dream)


func _on_transitioning_to_map() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	var map_scene := preload("res://levels_and_level_objects/map/map.tscn").instantiate()
	map_scene.new_scene = next_level
	add_child(map_scene)
	Fade.crossfade_execute() 
	GameEvents.map_started.emit(map_position, next_level)
	

func _on_morning_started() -> void:
	var start_day_ui := preload("res://user_interface/new_day_ui.tscn").instantiate()
	add_child(start_day_ui)

func _on_hunt_started() -> void:
	pass