extends Label


func _ready():
	GameEvents.player_money_changed.connect(_on_player_money_changed)
	
	var money_amt = SaveManager.load_item("money")
	if money_amt != null:
		text = str(money_amt)
	else:
		text = str(0)
	
	
	
func _on_player_money_changed(new_total) -> void:
	text = str(new_total)
