extends Area2D

@onready var animation_player := $"../Pivot/AnimationPlayer"
@onready var brick_hunger_bar := $"../HungerBars/BrickHungerBar"
@onready var plant_hunger_bar := $"../HungerBars/PlantHungerBar"
@onready var meat_hunger_bar := $"../HungerBars/MeatHungerBar"
var food_collected := 0
#@onready var collision_polygon := $"../CollisionPolygon2D"

func _ready():
	self.body_entered.connect(_generate_food)
	animation_player.play("idle")


func _generate_food(player) -> void:
	if player.bag.size() > 0:
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
				SoundPlayer.play_sound("glottal_stop")
		player.bag = []
		await get_tree().create_timer(1.0).timeout
		if food_collected > 0:
			SoundPlayer.play_sound("chew")
#			animation_player.play("chew")
			_choose_emotion()
		else:
			animation_player.play("idle")


func _choose_emotion() -> void:
	if food_collected > 3:
		SoundPlayer.play_sound("little_brother_happy")
#		_play_happy()
		animation_player.play("idle")
		food_collected = 0
	else:
		SoundPlayer.play_sound("little_brother_sad")
#		_play_sad()
		animation_player.play("idle")
		food_collected = 0
#	get_node("../CollisionPolygon2D").set_deferred("disabled", false)
	
	GameEvents.cutscene_ended.emit()


#func _play_happy():
#	await get_tree().create_timer(1.5).timeout
#	animation_player.play("happy")
#
#
#
#func _play_sad():
#	await get_tree().create_timer(1.7).timeout
#	animation_player.play("sad")
