extends State


func enter(_msg := {}) -> void:
	GameEvents.cutscene_started.emit()
	GameEvents.camera_change_focus.emit(owner)
	owner.animation_player.play("die")
	await get_tree().create_timer(2.0).timeout
	OS.delay_msec(80)
	var explode := preload("res://vfx/explosion.tscn").instantiate()
	explode.position = owner.global_position
	explode.big = true
	get_node("/root/World").add_child(explode)
	$"../../Pivot/Body".texture = preload("res://characters/enemy/paroot_boss/paroot_boss_phase_2.png")
	# screen white flash and screenshake
	GameEvents.big_explosion.emit()
	
	# meaty chunks sound
	
	# create drops
	if owner.death_pieces:
		var spread = 25 
		var new_velocity = Vector2(0, -15)
		var death_pieces_size = owner.death_pieces.size()
		var i = 0
		for sprite in owner.death_pieces:
			var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
			pickup.setup(sprite)
			var angle = i * 2 * PI / death_pieces_size
			i += 1
			pickup.position = owner.global_position + Vector2(cos(angle), sin(angle)) * spread
			pickup.velocity = new_velocity.rotated(angle)
			get_node("/root/World").call_deferred("add_child", pickup)
	GameEvents.cutscene_ended.emit()
	$"../../Pivot/Hurtbox".monitoring = true
	state_machine.transition_to("Charge")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
