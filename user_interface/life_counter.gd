extends Label

var lives_amt

func _ready():
	GameEvents.player_died.connect(_on_player_lives_changed)
	
	lives_amt = SaveManager.load_item("lives")
	if lives_amt != null:
		text = str(lives_amt)
	else:
		lives_amt = 5
		text = str(lives_amt)

func _on_player_lives_changed() -> void:
	lives_amt -= 1
	SaveManager.save_item("lives", lives_amt)
	text = str(lives_amt)
