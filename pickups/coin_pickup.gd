extends Pickup

func _add_pickup_to_inventory(player) -> void:
	if player is Player:
		player.money += 1
		GameEvents.player_money_changed.emit(player.money)
		_destroy(player.position)
