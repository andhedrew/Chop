extends CharacterBody2D

@export var dream_image: Texture
@export var map_position: int
@export_file("*.tscn") var next_level


@onready var brick_hunger_bar := $InteractZone/HungerBars/BrickHungerBar
@onready var plant_hunger_bar := $InteractZone/HungerBars/PlantHungerBar
@onready var meat_hunger_bar := $InteractZone/HungerBars/MeatHungerBar


var is_full := false

func _ready():
	z_index = SortLayer.PLAYER
	GameEvents.evening_started.connect(_on_start_of_evening)
	GameEvents.evening_ended.connect(_on_end_of_day)
#	$Hurtbox.area_entered.connect(_on_hitbox_entered)

func _process(_delta):
	var brick_full = brick_hunger_bar.value == brick_hunger_bar.max_value
	var plant_full = plant_hunger_bar.value == plant_hunger_bar.max_value
	var meat_full = meat_hunger_bar.value == meat_hunger_bar.max_value
	
	if brick_full and plant_full and meat_full and not is_full:
		_on_is_full()


func _on_is_full() -> void:
	$InteractZone/HungerBars.visible = false
	$FullMessage.visible = true
	is_full = true


func _on_start_of_evening() -> void:
	$FullMessage.visible = false



func _on_end_of_day() -> void:
	GameEvents.cutscene_started.emit()
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	get_tree().change_scene_to_file(next_level)
	Fade.crossfade_execute() 
	GameEvents.cutscene_ended.emit()
#func _on_hitbox_entered(hitbox) -> void:
#	if hitbox is HitBox:
#		health -= 1
#		SoundPlayer.play_sound("impact_celery")
#		$Pivot/EffectsPlayer.play("effects/take_damage")
#		$Pivot/AnimationPlayer.play("hurt")
#		await $Pivot/AnimationPlayer.animation_finished
#		$Pivot/AnimationPlayer.play("sad")
#
#
#func die() -> void:
#	call_deferred("queue_free")
#	OS.delay_msec(130)
#	var explode := preload("res://vfx/explosion.tscn").instantiate()
#	explode.position = global_position
#	explode.big = true
#	get_node("/root/").add_child(explode)
#	if death_pieces:
#		var spacing = 2
#		var starting_x = (death_pieces.size()*(spacing*.5))
#		for sprite in death_pieces:
#			var pickup := preload("res://pickups/food_pickup.tscn").instantiate()
#			pickup.setup(sprite)
#			pickup.position = global_position
#			pickup.velocity = Vector2(starting_x, randf_range(-4, -6))
#			starting_x -= spacing
#			get_node("/root/World").add_child(pickup)
