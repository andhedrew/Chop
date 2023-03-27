extends Pickup


func _add_pickup_to_inventory(player) -> void:
	player.food += 1
	player.bag.append($Sprite2D.texture)
	GameEvents.added_food_to_bag.emit($Sprite2D.texture)
