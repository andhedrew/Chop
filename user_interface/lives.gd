extends HBoxContainer

@onready var life_tex_rect: TextureRect = $TextureRect
var lives := 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var saved_lives = SaveManager.load_item("lives")
	if saved_lives:
		lives = saved_lives
	$Label.text = str(lives)
	GameEvents.player_died.connect(on_player_death)
	GameEvents.player_gained_life.connect(on_player_gained_life)
	




func on_player_death():
	lives -= 1
	$Label.text = str(lives)
	if lives == 1:
		life_tex_rect.texture = preload("res://user_interface/lives_almost_gone.png")


func on_player_gained_life():
	lives += 1
	$Label.text = str(lives)
