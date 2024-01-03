class_name TutorialLevelManager
extends LevelManager

var tutorial = {
	"enemy_execute_prompted": false,
	"adding_food_prompted": false,
	"done_feeding_prompted": false,
	"coin_prompted": false,
	"plant_bar_prompted": false,
	"full_bag_prompted": false,
}

var dialogue_running := false
var y_pos := -85.0


func _ready():
	super._ready()
	tutorial = SaveManager.load_item("tutorial")
	SaveManager.save_item("level", scene_file_path)
	GameEvents.enemy_took_damage.connect(_on_enemy_took_damage)
	GameEvents.added_food_to_bag.connect(_on_adding_food_to_bag)
	GameEvents.player_money_changed.connect(_on_collected_a_coin)
	GameEvents.dialogue_finished.connect(_on_finished_dialogue)
	GameEvents.mush_destroyed.connect(_on_mush_destroyed)


func _on_collected_a_coin(_money) -> void:
	if not SaveManager.load_item("tutorial/coin_prompted") and not dialogue_running:
		dialogue_running = true
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.header = [
			"Cash Money", 
			"Thrift",
			"Savings Plan",
			]
		dialogue.dialog = [
			"Found some cash.", 
			"Full coins are real rare, you'll mostly find bits.",
			"Save 'em up, buy yourself something nice." 
			]
		camera.add_child(dialogue)
		SaveManager.save_item("tutorial/coin_prompted", true)


func _on_adding_food_to_bag(_food) -> void:
	if not SaveManager.load_item("tutorial/adding_food_prompted") and not dialogue_running:
		dialogue_running = true
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.header = [
			"Lucky you", 
			"Feeding",
			]
		dialogue.dialog = [
			"Got some food in your bag.", 
			"Feed it to the beast later. If you want.", 
			]
		camera.add_child(dialogue)
		SaveManager.save_item("tutorial/adding_food_prompted", true)



func _on_enemy_took_damage(health) -> void:
	if not SaveManager.load_item("tutorial/enemy_execute_prompted") and health == 1 and not dialogue_running:
		dialogue_running = true
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.header = [
			"Got 'im Good", 
			"CHOP!", 
			"Cold Cuts"
			]
		dialogue.dialog = [
			"It's wounded, one health left.", 
			"While in the air, press S to CHOP!", 
			"CHOP enemies when they're wounded to slice 'em up into food."
			]
		
		camera.add_child(dialogue)
		dialogue.tut = 3
		SaveManager.save_item("tutorial/enemy_execute_prompted", true)
		
	else:
		print("SKIPPED ENEMY TOOK DAMAGE")


func _on_mush_destroyed() -> void:
	if not SaveManager.load_item("tutorial/mush_prompted") and not dialogue_running:
		dialogue_running = true
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.header = [
			"I don't eat mushrooms", 
			]
		dialogue.dialog = [
			"Not a pig, Not a junkie.", 
			]
		camera.add_child(dialogue)
		SaveManager.save_item("tutorial/enemy_execute_prompted", true)



func _on_finished_dialogue():
	dialogue_running = false
