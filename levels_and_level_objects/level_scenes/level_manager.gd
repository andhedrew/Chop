class_name LevelManager
extends Node2D

@export var dream_images: Array[Texture]
@export var map_position: float
@export_file("*.tscn") var next_level
@export var camera: Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
#	SoundPlayer.play_music("blues")
	GameEvents.evening_ended.connect(_on_evening_ended)
	GameEvents.transition_to_map.connect(_on_transitioning_to_map)
	GameEvents.morning_started.connect(_on_morning_started)
	GameEvents.continue_day.connect(_on_morning_started)
	SaveManager.save_item("level", scene_file_path)
	GameEvents.hunt_started.connect(_on_hunt_started)
#	GameEvents.player_died.connect(_restart_level)
	
	GameEvents.cutscene_started.connect(_cutscene_started)
	GameEvents.cutscene_ended.connect(_cutscene_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		_restart_level()
	if Input.is_action_just_pressed("reset_save_data"):
		SaveManager.reset_save()


func _restart_level() -> void:
	print_debug("restarting")
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().reload_current_scene()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
	Fade.crossfade_execute() 


func _on_evening_ended() -> void:
	var dream := preload("res://levels_and_level_objects/dream/dream.tscn").instantiate()
	dream.get_node("Dream/Sprite2D").texture = dream_images[0]
	dream.dream_slides = dream_images
	add_child(dream)


func _on_transitioning_to_map() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	var map_scene := preload("res://levels_and_level_objects/map/map.tscn").instantiate()
	map_scene.new_scene = next_level
	add_child(map_scene)
	Fade.crossfade_execute() 
	GameEvents.map_started.emit(map_position, next_level)


func _on_morning_started() -> void:
	var start_day_ui := preload("res://user_interface/shop.tscn").instantiate()
	await get_tree().create_timer(3.0).timeout
	add_child(start_day_ui)


func _on_hunt_started() -> void:
	pass


func _cutscene_started():
	print_debug("cutscene_started")


func _cutscene_ended():
	print_debug("cutscene_ended")
