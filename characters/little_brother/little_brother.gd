extends CharacterBody2D

@onready var brick_hunger_bar := $InteractZone/HungerBars/BrickHungerBar
@onready var plant_hunger_bar := $InteractZone/HungerBars/PlantHungerBar
@onready var meat_hunger_bar := $InteractZone/HungerBars/MeatHungerBar


var is_full := false

var state := Enums.State.IDLE


func _ready():
	z_index = SortLayer.PLAYER
	state = Enums.State.HUNGRY
	await get_tree().create_timer(3).timeout
	state = Enums.State.IDLE
	GameEvents.done_feeding_little_brother.connect(done_feeding)
	await get_tree().create_timer(0.1).timeout
	GameEvents.hunt_started.emit()


func _process(delta):
	if state == Enums.State.MOVE:
		position.x += 45 * delta


func done_feeding() -> void:
	is_full = true


func save_stomachs() -> void:
	SaveManager.save_item("brick_stomach", brick_hunger_bar.value)
	SaveManager.save_item("plant_stomach", plant_hunger_bar.value)
	SaveManager.save_item("meat_stomach", meat_hunger_bar.value)
