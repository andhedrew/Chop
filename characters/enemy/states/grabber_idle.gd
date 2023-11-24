class_name  GrabberIdle
extends WalkerIdle


func enter(_msg := {}) -> void:
	$"../../Hurtbox".set_deferred("monitoring", false)
	owner.animation_player.play("idle")
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.4
	if state_machine.previous_state == "Hurt":
		timer.wait_time = 0.1
	timer.one_shot = true
	timer.start()


func update(_delta: float) -> void:
	
		if player_detector.is_colliding() and timer.is_stopped():
			var detected_object = player_detector.get_collider()
			if detected_object is Player:
				state_machine.transition_to("Attack")
