extends Area2D


func _ready():
	self.body_entered.connect(_destroy_food)


func _destroy_food(food) -> void:
	food.call_deferred("queue_free")
