class_name  JumperIdle
extends WalkerIdle


func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	if state_machine.previous_state == "Hurt":
		timer.wait_time = 0.1
	timer.one_shot = true
	timer.start()


func update(_delta: float) -> void:
			
		owner.velocity.x = lerp(owner.velocity.x, owner.belt_speed, Param.FRICTION)
		owner.move_and_slide()


		if !owner.is_on_floor():
			state_machine.transition_to("Fall")
	
	
		if player_detector.is_colliding() and timer.is_stopped():
			var detected_object = player_detector.get_collider()
			if detected_object is Player:
				state_machine.transition_to("Attack")
