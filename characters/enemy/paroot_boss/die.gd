extends State


func enter(_msg := {}) -> void:
	$"../../Hitbox".set_deferred("monitoring", false)
	await get_tree().create_timer(0.3).timeout
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
	GameEvents.drop_coins.emit(bounty, owner.global_position)
	if owner.difficulty == 1:
		var pos := Vector2(owner.global_position.x, owner.global_position.y - 5)
		GameEvents.drop_food.emit(owner.difficulty_1_death_pieces, pos)
	# fanfare
	# camera zoom?
	# player animate victory (wipe brow, undersell it)
	GameEvents.cutscene_ended.emit()
	owner.call_deferred("queue_free")
	GameEvents.boss_defeated.emit()
