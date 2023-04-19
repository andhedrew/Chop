extends HBoxContainer

var value : int = 0
var capacity: int = 3
@onready var food_bag := $FoodBag
@onready var brick_hunger_bar := $"HungerBars/BrickHungerBar"
@onready var plant_hunger_bar := $"HungerBars/PlantHungerBar"
@onready var meat_hunger_bar := $"HungerBars/MeatHungerBar"

var brick_value := 0.0
var plant_value := 0.0
var meat_value := 0.0

func _ready():
	GameEvents.added_food_to_bag.connect(_on_gaining_food)
	GameEvents.removed_food_from_bag.connect(_on_losing_food)
	GameEvents.bag_capacity_changed.connect(_on_bag_capacity_changed)
	brick_hunger_bar.max_value = 100
	plant_hunger_bar.max_value = 100
	meat_hunger_bar.max_value = 100


func _on_gaining_food(pickup) -> void:
	food_bag.value += 1
	brick_value += pickup.brick_value
	plant_value += pickup.plant_value
	meat_value += pickup.meat_value
	
	var total_value := brick_value + plant_value + meat_value
	brick_hunger_bar.value = (brick_value / total_value)*100
	plant_hunger_bar.value = (plant_value / total_value)*100
	meat_hunger_bar.value = (meat_value / total_value)*100

func _on_losing_food(pickup) -> void:
	food_bag.value -= 1
	brick_value -= pickup.brick_value
	plant_value -= pickup.plant_value
	meat_value -= pickup.meat_value
	
	var total_value := brick_value + plant_value + meat_value
	
	brick_hunger_bar.value = brick_value/total_value
	plant_hunger_bar.value = plant_value/total_value
	meat_hunger_bar.value = meat_value/total_value


func _on_bag_capacity_changed(new_capacity: int) -> void:
	food_bag.max_value = new_capacity
