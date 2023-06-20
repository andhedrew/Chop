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
	GameEvents.drop_coins.emit(bounty, owner.global_position)
	# fanfare
	# camera zoom?
	# player animate victory (wipe brow, undersell it)
	GameEvents.cutscene_ended.emit()
	owner.call_deferred("queue_free")
	GameEvents.boss_defeated.emit()
