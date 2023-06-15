extends State


func enter(_msg := {}) -> void:
	GameEvents.cutscene_started.emit()
	GameEvents.camera_change_focus.emit(owner)
	owner.animation_player.play("die")
	await get_tree().create_timer(2.0).timeout
	
	# create explosion
	OS.delay_msec(80)
	var explode := preload("res://vfx/explosion.tscn").instantiate()
	explode.position = owner.global_position
	explode.big = true
	get_node("/root/World").add_child(explode)
	
	# screen white flash and screenshake
	GameEvents.big_explosion.emit()
	
	# meaty chunks sound
	
	# create drops
	var bounty = 32
	var spread = 6 # adjust this value to increase or decrease the spread of the pickups
	var new_velocity = Vector2(0, -12) # adjust this value to control the initial velocity of the pickups
	if bounty > 0:
		var coins = [8, 4, 2, 1]
		var total_coins = 0
		var bounty_tracker = bounty
		for coin in coins:
			total_coins += int(bounty_tracker / coin)
			if coin <= bounty_tracker:
				bounty_tracker = bounty_tracker % coin
		bounty = int(bounty)
		var i = 0
		for coin in coins:
			while bounty >= coin:
				var pickup = preload("res://pickups/coin_pickup.tscn").instantiate()
				var angle = i * 2 * PI / total_coins
				i += 1
				pickup.position = owner.global_position + Vector2(cos(angle), sin(angle)) * spread
				pickup.velocity = new_velocity.rotated(angle)
				pickup.value = coin
				get_node("/root/").call_deferred("add_child", pickup)
				bounty -= coin
	# fanfare
	# camera zoom?
	# player animate victory (wipe brow, undersell it)
	GameEvents.cutscene_ended.emit()
	owner.call_deferred("queue_free")
