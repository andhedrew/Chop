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

func _ready():
	tutorial = SaveManager.load_item("tutorial")
	GameEvents.evening_ended.connect(_on_evening_ended)
	GameEvents.transition_to_map.connect(_on_transitioning_to_map)
	GameEvents.morning_started.connect(_on_morning_started)
	SaveManager.save_item("level", scene_file_path)
	GameEvents.hunt_started.connect(_on_hunt_started)
	GameEvents.enemy_took_damage.connect(_on_enemy_took_damage)
	GameEvents.added_food_to_bag.connect(_on_adding_food_to_bag)
	GameEvents.done_feeding_little_brother.connect(_on_done_feeding)
	GameEvents.player_money_changed.connect(_on_collected_a_coin)
	GameEvents.plant_hunger_bar_filled.connect(_on_plant_bar_filled)
	GameEvents.bag_full.connect(_on_full_bag)


func _on_full_bag() -> void:
	if not SaveManager.load_item("tutorial/full_bag_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"Bag's full.", 
			"Won't be able to carry no more food until I feed him.",
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5)+95, -45.0)
		SaveManager.save_item("tutorial/full_bag_prompted", true)

func _on_plant_bar_filled() -> void:
	if not SaveManager.load_item("tutorial/plant_bar_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"His plant stomach's full.", 
			"Gotta find something else for him.",
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5)+95, -45.0)
		SaveManager.save_item("tutorial/plant_bar_prompted", true)

func _on_collected_a_coin(_money) -> void:
	if not SaveManager.load_item("tutorial/coin_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"Found some cash.", 
			"Full coins are real rare, you'll mostly find bits.",
			"Save 'em up, buy yourself something nice." 
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5), -45.0)
		SaveManager.save_item("tutorial/coin_prompted", true)


func _on_done_feeding() -> void:
	await get_tree().create_timer(0.2).timeout

	if not SaveManager.load_item("tutorial/done_feeding_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"He's got three stomachs in him.", 
			"Can't just stuff melon down his gullet all day.",
			"Once one stomach's full, gotta go hunting for something else." 
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5)+95, -45.0)
		
		SaveManager.save_item("tutorial/done_feeding_prompted", true)


func _on_adding_food_to_bag(_food) -> void:
	if not SaveManager.load_item("tutorial/adding_food_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"Got some food in your bag.", 
			"Go back any time to feed him.", 
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5),  -45.0)
		SaveManager.save_item("tutorial/adding_food_prompted", true)


func _on_hunt_started() -> void:
	if not SaveManager.load_item("tutorial/start_of_level_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"Won't go no farther without a meal.", 
			"Maybe chop up some melons - ",
			"they got faces, but they don't feel no pain.",
			"Most likely." ,
			"X to attack."]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5), -45.0)
		SaveManager.save_item("tutorial/start_of_level_prompted", true)


func _on_enemy_took_damage() -> void:
	if not SaveManager.load_item("tutorial/enemy_execute_prompted"):
		var dialogue = preload("res://user_interface/dialogue.tscn").instantiate()
		dialogue.dialog = [
			"It's bleeding, one health left.", 
			"1. Jump using Z", 
			"2. Press down in midair to execute a bleeding enemy",
			"Executed enemies drop food."
			]
		camera.add_child(dialogue)
		var dialogue_width := 180.0
		dialogue.position = Vector2(-(dialogue_width * 0.5), -45.0)
		SaveManager.save_item("tutorial/enemy_execute_prompted", true)
