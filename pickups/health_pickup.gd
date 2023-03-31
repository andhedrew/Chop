extends Pickup

func _add_pickup_to_inventory(player) -> void:
	if player is Player:
		if player.health+1 < player.max_health:
			player.health += 2
			GameEvents.player_health_changed.emit(player.health, player.max_health)
		elif player.health+1 == player.max_health:
			player.health += 1
			GameEvents.player_health_changed.emit(player.health, player.max_health)
	_destroy(player.position)
