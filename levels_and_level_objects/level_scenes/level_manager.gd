class_name LevelManager
extends Node2D

@export var dream_images: Array[Texture]
@export var map_position: float
@export var next_map: PackedScene
@export_file("*.tscn") var next_level
@export var camera: Camera2D
@export var checkpoint: bool = false
@export var skip_map_after_this_level: bool = false

var skip_map := false



# Called when the node enters the scene tree for the first time.
func _ready():
#	SoundPlayer.play_music("blues")
	GameEvents.evening_ended.connect(_on_evening_ended)
	GameEvents.transition_to_map.connect(_on_transitioning_to_map)
	GameEvents.morning_started.connect(_on_morning_started)
	GameEvents.continue_day.connect(_on_morning_started)
	SaveManager.save_item("level", scene_file_path)
	GameEvents.hunt_started.connect(_on_hunt_started)
#	GameEvents.player_died.connect(_restart_level)
	
	GameEvents.cutscene_started.connect(_cutscene_started)
	GameEvents.cutscene_ended.connect(_cutscene_ended)
	
	GameEvents.drop_food.connect(drop_food)
	GameEvents.drop_health.connect(drop_health)
	GameEvents.drop_coins.connect(drop_coins)
	GameEvents.new_vfx.connect(vfx)
	GameEvents.new_score_label.connect(_new_score_label)
	GameEvents.player_died.connect(_on_player_lives_changed)

	
	if checkpoint: #THIS IS THE WORLD CHECKPOINT
		SaveManager.save_item("checkpoint", get_tree().current_scene.scene_file_path)
	
	
	var start_at_checkpoint = SaveManager.load_item("checkpoint_reached_this_level")
	var checkpoint_pos = SaveManager.load_item("checkpoint_position")
	
	if start_at_checkpoint:
		$Player.position = checkpoint_pos


func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		_restart_level()
	if Input.is_action_just_pressed("reset_save_data"):
		SaveManager.reset_save()


func _restart_level() -> void:
	var lives_amt = SaveManager.load_item("lives")

	GameEvents.restarted_level.emit()
	
	if lives_amt == null:
		lives_amt = 5
		
	if lives_amt > 0:
		GameEvents.cutscene_started.emit()
		Fade.crossfade_prepare(0.4, "ChopHorizontal")
		SoundPlayer.play_sound("paper_rip")
		get_tree().reload_current_scene()
		get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
		Fade.crossfade_execute() 

	else:
		SaveManager.save_item("checkpoint_reached_this_level", false)
		SaveManager.save_item("checkpoint_position", Vector2.ZERO)
		GameEvents.cutscene_started.emit()
		Fade.crossfade_prepare(0.4, "ChopHorizontal")
		SoundPlayer.play_sound("paper_rip")
		get_tree().change_scene_to_file("res://user_interface/out_of_lives.tscn")
		Fade.crossfade_execute() 


func _on_evening_ended() -> void:
	var dream := preload("res://levels_and_level_objects/dream/dream.tscn").instantiate()
	dream.get_node("Dream/Sprite2D").texture = dream_images[0]
	dream.dream_slides = dream_images
	add_child(dream)


func _on_transitioning_to_map() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	var map_scene = load(next_map.get_path()).instantiate()
	map_scene.new_scene = next_level
	add_child(map_scene)
	Fade.crossfade_execute() 
	GameEvents.map_started.emit(map_position, next_level)


func transition_to_level(level:String) -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(level)
	Fade.crossfade_execute() 


func transition_to_next_level() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(next_level)
	Fade.crossfade_execute() 

func _on_morning_started() -> void:
	var start_day_ui := preload("res://user_interface/shop.tscn").instantiate()
	await get_tree().create_timer(3.0).timeout
	add_child(start_day_ui)


func _on_hunt_started() -> void:
	pass


func _cutscene_started():
	print_debug("cutscene_started")


func _cutscene_ended():
	print_debug("cutscene_ended")


func drop_food(food : Array, drop_position : Vector2) -> void:
	print_debug("dropping food")
	var spread = 6 # adjust this value to increase or decrease the spread of the pickups
	var new_velocity = Vector2(0, -12) # adjust this value to control the initial velocity of the pickups
	var food_size = food.size()
	var i = 0
	for sprite in food:
		var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
		pickup.setup(sprite)
		pickup.z_index = SortLayer.FOREGROUND
		var angle = (PI/2) + (i * PI / food_size) + 180
		i += 1
		pickup.position = drop_position + Vector2(cos(angle), sin(angle)) * spread
		pickup.velocity = new_velocity.rotated(angle)
		
		call_deferred("add_child", pickup)
		


func drop_health(drop_position : Vector2) -> void:
	var sprite := preload("res://user_interface/healthbar/full_heart.png")
	var pickup := preload("res://pickups/health_pickup.tscn").instantiate()
	var new_velocity = Vector2(0, -6)
	pickup.setup(sprite)
	pickup.position = drop_position
	pickup.velocity = new_velocity
	call_deferred("add_child", pickup)


func drop_coins(bounty: int, drop_position : Vector2) -> void:
	var new_velocity = Vector2(0, -12) # adjust this value to control the initial velocity of the pickups
	if bounty > 0:
		var coins = [8, 4, 2, 1]
		var total_coins = 0
		var bounty_tracker = bounty
		for coin in coins:
			total_coins += int(bounty_tracker / coin)
			if coin <= bounty_tracker:
				bounty_tracker = bounty_tracker % coin
		bounty = int(bounty)
		var i = 0
		for coin in coins:
			while bounty >= coin:
				var pickup = preload("res://pickups/coin_pickup.tscn").instantiate()
				var angle = (PI/2) + (i * PI / total_coins) + 180
				i += 1
				pickup.position = drop_position
				pickup.velocity = new_velocity.rotated(angle)
				pickup.value = coin
				call_deferred("add_child", pickup)
				bounty -= coin


func vfx(effect : String, vfx_position : Vector2) -> void:
	var new_vfx = load(effect).instantiate()
	new_vfx.position = vfx_position
	call_deferred("add_child", new_vfx)


func _new_score_label(amount: int, new_position: Vector2) -> void:
	var label := preload("res://user_interface/score_number.tscn").instantiate()
	label.score = amount
	label.position = new_position
	add_child(label)


func _on_player_lives_changed() -> void:
	var lives_amt = SaveManager.load_item("lives")
	if lives_amt == null:
		lives_amt = 5
	lives_amt -= 1
	SaveManager.save_item("lives", lives_amt)
