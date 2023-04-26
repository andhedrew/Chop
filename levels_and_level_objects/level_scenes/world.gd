extends Node2D

@export var dream_image: Texture
@export var map_position: int
@export_file("*.tscn") var next_level
@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	SoundPlayer.play_music("blues")
	GameEvents.evening_ended.connect(_on_evening_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().reload_current_scene()


func _on_evening_ended() -> void:
	var dream := preload("res://levels_and_level_objects/dream/dream.tscn").instantiate()
	dream.get_node("Dream/Sprite2D").texture = dream_image
	add_child(dream)



func _on_end_of_day() -> void:
	GameEvents.cutscene_started.emit()
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	get_tree().change_scene_to_file(next_level)
	Fade.crossfade_execute() 
	GameEvents.cutscene_ended.emit()
