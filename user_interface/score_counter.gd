extends Label

var score := 0
func _ready():
	GameEvents.player_score_changed.connect(_on_player_score_changed)
	
	var score_amt = SaveManager.load_item("score")
	if score_amt != null:
		text = str(score_amt)
	else:
		score = 0
		text = str(score)
	
	
	
func _on_player_score_changed(addition: int, reset: bool) -> void:
	if reset:
		reset_score()
	else:
		var score_amt = SaveManager.load_item("score")
		if score_amt != null:
			score_amt += addition
			SaveManager.save_item("score", score_amt)
		else: 
			score_amt = addition
			SaveManager.save_item("score", score_amt)
		text = str(score_amt)



func reset_score():
	if score > 0:
		score -= 1
		SoundPlayer.play_sound("click")
		text = str(score)
		await get_tree().create_timer(0.1).timeout
		reset_score()
	else:
		SaveManager.save_item("score", 0)
		text = str(0)
