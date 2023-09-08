extends Label

@export_enum("meat_score", "plant_score", "brick_score") var score_to_track: String


func _ready():
	SaveManager.save_item("meat_score", 5)
	SaveManager.save_item("plant_score", 7)
	SaveManager.save_item("brick_score", 2)
	var score = SaveManager.load_item(str(score_to_track))
	text = str(score)

