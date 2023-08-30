extends Control

@onready var lives_label := $ColorRect/Control/HBoxContainer/Label2
var lives = 0
var score = 0
var score_divider: float = 0.0

func _ready():
	lives_label.text = str(lives)
	score = SaveManager.load_item("score")
	score_divider = score/5
	increment_lives()
	reset_score()

func increment_lives():
	if lives < 5:
		lives += 1
		SoundPlayer.play_sound("pickup_2")
		lives_label.text = str(lives)
		await get_tree().create_timer(0.5).timeout
		increment_lives()
	else:
		await get_tree().create_timer(1.0).timeout
		SaveManager.save_item("lives", 5)
		var current_level = SaveManager.load_item("level")
		Fade.crossfade_prepare(0.4, "ChopHorizontal")
		SoundPlayer.play_sound("paper_rip")
		get_tree().change_scene_to_file(current_level)
		Fade.crossfade_execute()



func reset_score():
	if score > 0:
		score -= score_divider
		SoundPlayer.play_sound("click")
		$ColorRect/Control/HBoxContainer2/Label2.text = str(score)
		await get_tree().create_timer(0.5).timeout
		reset_score()
	else:
		SaveManager.save_item("score", 0)
		$ColorRect/Control/HBoxContainer2/Label2.text = str(0)
