extends State


func enter(_msg := {}) -> void:

	if owner.difficulty != 1:
		GameEvents.cutscene_started.emit()
		owner.animation_player.play("die")
		await get_tree().create_timer(2.0).timeout
		OS.delay_msec(80)
		var explode := preload("res://vfx/explosion.tscn").instantiate()
		explode.position = owner.global_position
		explode.big = true
		get_node("/root/World").add_child(explode)
		# screen white flash and screenshake
		GameEvents.big_explosion.emit()
		$"../../Pivot/Body".texture = preload("res://characters/enemy/paroot_boss/paroot_boss_phase_2.png")
	
	if owner.difficulty != 1:
		var pos := Vector2(owner.global_position.x, owner.global_position.y - 5)
		GameEvents.drop_food.emit(owner.death_pieces, pos)
		GameEvents.cutscene_ended.emit()
		
	$"../../Pivot/Hurtbox".set_deferred("monitoring", true)
	state_machine.phase = 2
	state_machine.transition_to("Charge")
	
