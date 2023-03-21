extends Pickup


func _add_pickup_to_inventory(player) -> void:
	player.food += 1
