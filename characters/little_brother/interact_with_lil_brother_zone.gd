extends Area2D

@onready var animation_player := $"../Pivot/AnimationPlayer"
@onready var brick_hunger_bar := $"HungerBars/BrickHungerBar"
@onready var plant_hunger_bar := $"HungerBars/PlantHungerBar"
@onready var meat_hunger_bar := $"HungerBars/MeatHungerBar"
@onready var fade_animation_player := $FadeAnimations
var food_collected := 0
#@onready var collision_polygon := $"../CollisionPolygon2D"
var player_in_zone = false
var player : CharacterBody2D = null
func _ready():
	fade_animation_player.play("RESET")
	self.body_entered.connect(_on_player_entered)
	self.body_exited.connect(_on_player_exited)
	animation_player.play("idle")
	brick_hunger_bar.max_value = 12
	plant_hunger_bar.max_value = 12
	meat_hunger_bar.max_value = 12
	$Particles1.emitting = false
	$Particles2.emitting = false
	$Particles3.emitting = false


func _process(delta):
	if player_in_zone and Input.is_action_just_pressed("ui_down") and owner.is_full:
		_sing_song()
	elif player_in_zone and Input.is_action_just_pressed("ui_down"):
		_generate_food(player)
	
	if owner.is_full:
		$Label.text = "LULL"
		$Particles1.emitting = true
		$Particles2.emitting = true
		$Particles3.emitting = true
		$Label.visible = true


func _on_player_entered(body):
	player = body

	player_in_zone = true
	
	if player.bag.size() > 0 and !owner.is_full:
		fade_animation_player.play("fade_in")
		$Label.text = "FEED"
		$Particles1.emitting = true
		$Particles2.emitting = true
		$Particles3.emitting = true
	elif owner.is_full:
		fade_animation_player.play("fade_in")
		$Label.text = "LULL"
		$Particles1.emitting = true
		$Particles2.emitting = true
		$Particles3.emitting = true
	else:
		fade_animation_player.play("fade_in_food")
		$Label.text = ""
		


func _on_player_exited(_body):
		player_in_zone = false
		
		$Particles1.emitting = false
		$Particles2.emitting = false
		$Particles3.emitting = false
		if $Label.text == "":
			fade_animation_player.play("fade_out_food")
		else:
			fade_animation_player.play("fade_out")
		


func _generate_food(player) -> void:
	if player.bag.size() > 0 and not owner.is_full:
		GameEvents.cutscene_started.emit()
		player.facing = Enums.Facing.LEFT
#		get_node("../CollisionPolygon2D").set_deferred("disabled", true)
		animation_player.play("eat")
		for item in player.bag:
				
				var pickup := preload("res://pickups/food_pickup.tscn").instantiate()
				pickup.setup(item)
				get_node("/root/World").call_deferred("add_child", pickup)
				pickup.sort_layer = SortLayer.BACKGROUND
				pickup.position = $FoodSpawn.global_position
				pickup.velocity = Vector2(0, randf_range(-4, -6))
				GameEvents.removed_food_from_bag.emit(pickup)
				food_collected += 1
				brick_hunger_bar.value += pickup.brick_value
				plant_hunger_bar.value += pickup.plant_value
				meat_hunger_bar.value += pickup.meat_value
				await get_tree().create_timer(0.3).timeout

		player.bag = []
		await get_tree().create_timer(1.0).timeout
		GameEvents.cutscene_ended.emit()
		animation_player.play("idle")


func _choose_emotion() -> void:
	pass

func _sing_song():
#	GameEvents.cutscene_started.emit()
	pass
