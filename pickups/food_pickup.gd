extends Pickup


func _add_pickup_to_inventory(player) -> void:
	if player.bag_capacity > player.bag.size():
		player.bag.append($Sprite2D.texture)
		GameEvents.added_food_to_bag.emit($Sprite2D.texture)
		_destroy(player.position)
