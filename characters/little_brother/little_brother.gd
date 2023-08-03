extends CharacterBody2D

@onready var brick_hunger_bar := $InteractZone/HungerBars/BrickHungerBar
@onready var plant_hunger_bar := $InteractZone/HungerBars/PlantHungerBar
@onready var meat_hunger_bar := $InteractZone/HungerBars/MeatHungerBar


var is_full := false

var state := Enums.State.IDLE


func _ready():
	GameEvents.cutscene_started.emit()
	z_index = SortLayer.PLAYER
	var brick_stomach = SaveManager.load_item("brick_stomach")
	if brick_stomach != null:
		brick_hunger_bar.value = brick_stomach
	var plant_stomach = SaveManager.load_item("plant_stomach")
	if plant_stomach != null:
		plant_hunger_bar.value = plant_stomach
	var meat_stomach = SaveManager.load_item("meat_stomach")
	if meat_stomach != null:
		meat_hunger_bar.value = meat_stomach
	
	if brick_hunger_bar.value + plant_hunger_bar.value + meat_hunger_bar.value == 0:
		state = Enums.State.MOVE
		await get_tree().create_timer(2).timeout
		state = Enums.State.HUNGRY
		await get_tree().create_timer(3).timeout
		SaveManager.save_item("lb_position", position.x)
	else:
		var pos : Vector2 = Vector2(SaveManager.load_item("lb_position"), position.y)
		if pos != null:
			position = pos
	state = Enums.State.IDLE
	
	GameEvents.evening_started.connect(_on_start_of_evening)
	GameEvents.done_feeding_little_brother.connect(save_stomachs)
	
	await get_tree().create_timer(0.1).timeout
	GameEvents.cutscene_ended.emit()
	GameEvents.hunt_started.emit()


func _process(_delta):
	var brick_full = brick_hunger_bar.value == brick_hunger_bar.max_value
	var plant_full = plant_hunger_bar.value == plant_hunger_bar.max_value
	var meat_full = meat_hunger_bar.value == meat_hunger_bar.max_value
	
	if brick_full and plant_full and meat_full and not is_full:
		_on_is_full()
	
	if state == Enums.State.MOVE:
		position.x += 0.75
	


func _on_is_full() -> void:
	$InteractZone/HungerBars.visible = false
	$FullMessage.visible = true
	is_full = true


func _on_start_of_evening() -> void:
	$FullMessage.visible = false


func clear_stomachs() -> void:
	SaveManager.save_item("brick_stomach", 0.0)
	SaveManager.save_item("plant_stomach", 0.0)
	SaveManager.save_item("meat_stomach", 0.0)


func save_stomachs() -> void:
	SaveManager.save_item("brick_stomach", brick_hunger_bar.value)
	SaveManager.save_item("plant_stomach", plant_hunger_bar.value)
	SaveManager.save_item("meat_stomach", meat_hunger_bar.value)
