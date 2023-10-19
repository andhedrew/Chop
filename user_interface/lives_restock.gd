extends Control

@onready var lives_label := $ColorRect/Control/HBoxContainer/Label2
var lives = 0
var score = 0
var score_divider: float = 0.0



var map_position: float
var next_map: String
var next_level: String



func _ready():
	lives_label.text = str(lives)
	score = SaveManager.load_item("score")
	score_divider = score/5.0
	increment_lives()
	

func increment_lives():
	reset_score()
	if lives < 5:
		lives += 1
		SoundPlayer.play_sound("pickup_2")
		
		score = SaveManager.load_item("score")
		lives_label.text = str(lives)
		await get_tree().create_timer(0.5).timeout
		increment_lives()
	else:
		await get_tree().create_timer(1.0).timeout
		SaveManager.save_item("lives", 5)
		SaveManager.save_item("score", 0)
		_on_transitioning_to_map()


func reset_score():
	
	if score > 0:
		score -= score_divider
		SoundPlayer.play_sound("click")
		$ColorRect/Control/HBoxContainer2/Label2.text = str(round(abs(score)))
		await get_tree().create_timer(0.5).timeout
		reset_score()
	else:
		SaveManager.save_item("score", 0)
		$ColorRect/Control/HBoxContainer2/Label2.text = str(0)


func _on_transitioning_to_map() -> void:
	var checkpoint_level = SaveManager.load_item("checkpoint")
	if checkpoint_level != null:
		next_map = LevelInfo.LEVEL_MAP[checkpoint_level]
		next_level = checkpoint_level
	else:
		var baselevel:= "res://levels_and_level_objects/level_scenes/world_1_levels/1-1.tscn"
		next_map = LevelInfo.LEVEL_MAP[baselevel]
		next_level = baselevel
	
	
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	var map_scene = load(next_map).instantiate()
	map_scene.new_scene = next_level
	add_child(map_scene)
	Fade.crossfade_execute() 
	GameEvents.map_started.emit(0, next_level)
