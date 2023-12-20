extends Area2D

@onready var brick_hunger_bar := $"HungerBars/BrickHungerBar"
@onready var plant_hunger_bar := $"HungerBars/PlantHungerBar"
@onready var meat_hunger_bar := $"HungerBars/MeatHungerBar"
@onready var fade_animation_player := $FadeAnimations

var food_collected := 0
var label_text := ""
var player_in_zone = false
var player_object : CharacterBody2D = null
var cutscene_running := false
var faded_in := false
var food_faded_in := false
var active := true

func _ready():
	fade_animation_player.play("RESET")
	self.body_entered.connect(_on_player_entered)
	self.body_exited.connect(_on_player_exited)
	GameEvents.cutscene_started.connect(_on_cutscene_started)
	GameEvents.cutscene_ended.connect(_on_cutscene_ended)
	GameEvents.start_spider_chase.connect(_deactivate)
	brick_hunger_bar.max_value = 12
	plant_hunger_bar.max_value = 12
	meat_hunger_bar.max_value = 12
	$Particles1.emitting = false
	$Particles2.emitting = false
	$Particles3.emitting = false



func _process(_delta):
	if active:
		$Label.text = label_text
		if not cutscene_running:
			var player_interacting = player_in_zone and Input.is_action_just_pressed("ui_down")
			if player_interacting and owner.is_full and not owner.last_level:
				_end_level()
			elif player_interacting and owner.is_full:
				_start_spider_chase()
			elif player_interacting:
				GameEvents.started_feeding_little_brother.emit()
				_generate_food(player_object)

			if owner.is_full:
				$Particles1.emitting = true
				$Particles2.emitting = true
				$Particles3.emitting = true
				$Label.visible = true
		else:
			$Particles1.emitting = false
			$Particles2.emitting = false
			$Particles3.emitting = false
			$Label.visible = false


func _on_player_entered(body):
	if active:
		player_object = body
		
		if player_object.bag.size() > 0 and !owner.is_full:
			fade_animation_player.play("fade_in")
			faded_in = true
			label_text = "FEED"
			$Particles1.emitting = true
			$Particles2.emitting = true
			$Particles3.emitting = true
		elif owner.is_full:
			fade_animation_player.play("fade_in")
			faded_in = true
			$Particles1.emitting = true
			$Particles2.emitting = true
			$Particles3.emitting = true
		else:
			fade_animation_player.play("fade_in_food")
			$Label.text = ""
			
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
		else:
			fade_animation_player.play("fade_out_food")



func _generate_food(player) -> void:
	
	var wait_time := 0.3
	if player.bag.size() > 100:
		wait_time = 0.1
		
	if player.bag.size() > 0 and not owner.is_full:
		fade_animation_player.play("fade_out_non_food")
		faded_in = false
		food_faded_in = true
		GameEvents.cutscene_started.emit()

		player.facing = Enums.Facing.LEFT
		for item in player.bag:
				
				var pickup := preload("res://pickups/food_pickup.tscn").instantiate()
				var texture = load(item)
				pickup.setup(texture)
				owner.get_node("BeakCollider").disabled = true
				owner.get_node("HeadCollider").disabled = true
				owner.get_node("CollisionShape2D").disabled = true
				get_node("/root/World").call_deferred("add_child", pickup)
				pickup.sort_layer = SortLayer.BACKGROUND
				pickup.position = $FoodSpawn.global_position
				pickup.velocity = Vector2(0, randf_range(-4, -6))
				GameEvents.removed_food_from_bag.emit(pickup)
				food_collected += 1
				brick_hunger_bar.value += pickup.brick_value
				plant_hunger_bar.value += pickup.plant_value
				meat_hunger_bar.value += pickup.meat_value
				await get_tree().create_timer(wait_time).timeout
				SoundPlayer.play_sound("glottal_stop")
				
		await get_tree().create_timer(1.0).timeout
		owner.get_node("BeakCollider").disabled = false
		owner.get_node("HeadCollider").disabled = false
		owner.get_node("CollisionShape2D").disabled = false
		player.bag = []
		SaveManager.save_item("bag", [])
		
		if plant_hunger_bar.value == plant_hunger_bar.max_value:
			GameEvents.plant_hunger_bar_filled.emit()
		GameEvents.done_feeding_little_brother.emit()
		if owner.is_full:
			label_text = "LULL"



func _end_level():
	GameEvents.cutscene_started.emit()
	GameEvents.evening_started.emit()


func _on_cutscene_started() -> void:
	cutscene_running = true



func _on_cutscene_ended() -> void:
	cutscene_running = false
	monitoring = true
	if player_in_zone:
		if player_object.bag.size() > 0 and !owner.is_full:
			fade_animation_player.play("fade_in")
			faded_in = true
			label_text = "FEED"
			$Particles1.emitting = true
			$Particles2.emitting = true
			$Particles3.emitting = true
		elif owner.is_full:
			fade_animation_player.play("fade_in")
			faded_in = true
			$Particles1.emitting = true
			$Particles2.emitting = true
			$Particles3.emitting = true
		else:
			
			if not food_faded_in:
				fade_animation_player.play("fade_in_food")
				food_faded_in = true
			$Label.text = ""


func _start_spider_chase():
	SaveManager.save_item("spider_triggered", true)
#	GameEvents.cutscene_started.emit()
	GameEvents.start_spider_chase.emit()


func _deactivate():
	active = false
