extends CharacterBody2D

@onready var brick_hunger_bar := $InteractZone/HungerBars/BrickHungerBar
@onready var plant_hunger_bar := $InteractZone/HungerBars/PlantHungerBar
@onready var meat_hunger_bar := $InteractZone/HungerBars/MeatHungerBar


var is_full := false

var state := Enums.State.IDLE


func _ready():
	z_index = SortLayer.PLAYER
	GameEvents.evening_started.connect(_on_start_of_evening)
	state = Enums.State.MOVE
	await get_tree().create_timer(2).timeout
	state = Enums.State.HUNGRY
	await get_tree().create_timer(3).timeout
	state = Enums.State.IDLE
	GameEvents.cutscene_ended.emit()
	GameEvents.hunt_started.emit()

func _process(_delta):
	var brick_full = brick_hunger_bar.value == brick_hunger_bar.max_value
	var plant_full = plant_hunger_bar.value == plant_hunger_bar.max_value
	var meat_full = meat_hunger_bar.value == meat_hunger_bar.max_value
	
	if brick_full and plant_full and meat_full and not is_full:
		_on_is_full()
	
	if state == Enums.State.MOVE:
		position.x += 0.5


func _on_is_full() -> void:
	$InteractZone/HungerBars.visible = false
	$FullMessage.visible = true
	is_full = true


func _on_start_of_evening() -> void:
	$FullMessage.visible = false
