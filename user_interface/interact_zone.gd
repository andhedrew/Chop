extends Area2D

@onready var fade_animation_player := $FadeAnimations

var food_collected := 0
var label_text := ""
var player_in_zone = false
var player_object : CharacterBody2D = null
var cutscene_running := false
var faded_in := false

var active := true

var symbols1 = [1,1,1,1,1,1,1,1,1,1,1,1, 2, 3]
var symbols2 = [1,1,1,1,1,1,1,1,1,1,1,1, 2, 3]
var symbols3 = [1,1,1,1,1,1,1,1,1,1,1,1, 2, 3]

func _ready():
	fade_animation_player.play("RESET")
	self.body_entered.connect(_on_player_entered)
	self.body_exited.connect(_on_player_exited)
	GameEvents.cutscene_started.connect(_on_cutscene_started)
	GameEvents.cutscene_ended.connect(_on_cutscene_ended)
	GameEvents.start_spider_chase.connect(_deactivate)
	$Particles1.emitting = false
	$Particles2.emitting = false
	$Particles3.emitting = false



func _process(_delta):
	if active:
		$Label.text = label_text
		if not cutscene_running:
			var player_interacting = player_in_zone and Input.is_action_just_pressed("ui_down")
			if player_interacting:
				_generate_food(player_object)

		else:
			$Particles1.emitting = false
			$Particles2.emitting = false
			$Particles3.emitting = false
			$Label.visible = false


func _on_player_entered(body):
	if active:
		player_object = body
		
		if player_object.bag.size() > 0:
			fade_animation_player.play("fade_in")
			faded_in = true
			label_text = "GAMBLE"
			$Particles1.emitting = true
			$Particles2.emitting = true
			$Particles3.emitting = true

		player_in_zone = true


func _on_player_exited(_body):
	if active:
		player_in_zone = false
		$Particles1.emitting = false
		$Particles2.emitting = false
		$Particles3.emitting = false
		if faded_in:
			fade_animation_player.play("fade_out")
			faded_in = false




func _generate_food(player) -> void:
	if player.bag.size() > 0:
		var item = load(player.bag.pop_back())
		var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
		var no_collision := false
		pickup.setup(item, no_collision)
		get_node("/root/World").call_deferred("add_child", pickup)
		pickup.sort_layer = SortLayer.BACKGROUND
		pickup.feeding = true
		pickup.position = $FoodSpawn.global_position
		pickup.velocity = Vector2(0, randf_range(-4, -6))
	
		GameEvents.removed_food_from_bag.emit(pickup)
		SaveManager.save_item("bag", [])
		var results = spin_reels()
		calculate_payout(results)
		await get_tree().create_timer(0.3).timeout


func spin_reels() -> Array:
	var reel_results = []
	reel_results.append(symbols1[randi() % symbols1.size()])
	reel_results.append(symbols2[randi() % symbols2.size()])
	reel_results.append(symbols3[randi() % symbols3.size()])
	print_debug("reel_results: " + str(reel_results))
	GameEvents.slots_activated.emit(reel_results)
	return reel_results


func calculate_payout(results: Array) -> int:
	if results[0] == results[1] and results[1] == results[2]:
		_get_winnings()
	return 0

func _get_winnings():
	GameEvents.drop_coins.emit(1, global_position)

func _on_cutscene_started() -> void:
	cutscene_running = true


func _on_cutscene_ended() -> void:
	cutscene_running = false


func _deactivate():
	active = false
