extends CharacterBody2D

@onready var brick_hunger_bar := $InteractZone/HungerBars/BrickHungerBar
@onready var plant_hunger_bar := $InteractZone/HungerBars/PlantHungerBar
@onready var meat_hunger_bar := $InteractZone/HungerBars/MeatHungerBar
@export var last_level := false

var is_full := false

var state := Enums.State.IDLE
var running_from_spider := false

func _ready():
	GameEvents.start_spider_chase.connect(start_spider_chase)
	z_index = SortLayer.PLAYER
	state = Enums.State.IDLE
#	await get_tree().create_timer(3).timeout
	state = Enums.State.IDLE
	GameEvents.done_feeding_little_brother.connect(done_feeding)
	await get_tree().create_timer(0.1).timeout
	GameEvents.hunt_started.emit()
	


func _process(delta):
	if running_from_spider and state == Enums.State.IDLE:
		state = Enums.State.MOVE
	if state == Enums.State.MOVE:
		position.x += 45 * delta


func done_feeding() -> void:
	is_full = true


func save_stomachs() -> void:
	SaveManager.save_item("brick_stomach", brick_hunger_bar.value)
	SaveManager.save_item("plant_stomach", plant_hunger_bar.value)
	SaveManager.save_item("meat_stomach", meat_hunger_bar.value)

func start_spider_chase():
	state = Enums.State.MOVE
	running_from_spider = true
