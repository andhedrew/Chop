extends Label

@export_enum("meat_score", "plant_score", "brick_score") var score_to_track: String
var score

func _ready():
	GameEvents.added_food_to_bag.connect(_on_gaining_food)
	GameEvents.removed_food_from_bag.connect(_on_losing_food)
	score = SaveManager.load_item(str(score_to_track))
	if score == null:
		score = 0
	text = str(score)



func _on_gaining_food(pickup) -> void:
	match score_to_track:
		"meat_score":
			score += pickup.meat_value
		"plant_score":
			score += pickup.plant_value
		"brick_score":
			score += pickup.brick_value
	SaveManager.save_item(str(score_to_track), score)
	text = str(score)


func _on_losing_food(pickup) -> void:
	match score_to_track:
		"meat_score":
			score -= pickup.meat_value
		"plant_score":
			score -= pickup.plant_value
		"brick_score":
			score -= pickup.brick_value
	SaveManager.save_item(str(score_to_track), score)
	text = str(score)
