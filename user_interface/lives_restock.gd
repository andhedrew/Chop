extends Control

@onready var lives_label := $ColorRect/Control/HBoxContainer/Label2
var lives = 0

func _ready():
	lives_label.text = str(lives)
	
	increment_lives()

func increment_lives():
	if lives < 5:
		lives += 1
		SoundPlayer.play_sound("pickup_2")
		lives_label.text = str(lives)
		await get_tree().create_timer(0.5).timeout
		increment_lives()
	else:
		SaveManager.save_item("lives", 5)
		var current_level = SaveManager.load_item("level")
		Fade.crossfade_prepare(0.4, "ChopHorizontal")
		SoundPlayer.play_sound("paper_rip")
		get_tree().change_scene_to_file(current_level)
		Fade.crossfade_execute()
