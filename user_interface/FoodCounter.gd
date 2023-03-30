extends Label

var value : int = 0
var capacity: int = 3
func _ready():
	GameEvents.added_food_to_bag.connect(_on_gaining_food)
	GameEvents.removed_food_from_bag.connect(_on_losing_food)
	GameEvents.bag_capacity_changed.connect(_on_bag_capacity_changed)


func _process(_delta):
	text = str("Food: " + str(value) + "/" + str(capacity))


func _on_gaining_food(_texture) -> void:
	value += 1

func _on_losing_food() -> void:
	value -= 1


func _on_bag_capacity_changed(new_capacity: int) -> void:
	capacity = new_capacity
