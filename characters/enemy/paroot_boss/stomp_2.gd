extends State


var jumped := false

func enter(_msg := {}) -> void:
	jumped = false
	owner.animation_player.play("stomp")


func update(delta):
	owner.move_and_slide()
	if jumped:
		owner.velocity.y += Param.GRAVITY * delta
	else:
		owner.velocity.x = lerp(owner.velocity.x, 0.0, 0.2)
	
	if jumped and owner.is_on_floor() and state_machine.state_timer > 0.1:
		jumped = false
		GameEvents.boss_stomped.emit()
		if owner.animation_player.animation_finished:
			state_machine.transition_to("Charge")


func add_velocity() -> void:
	owner.velocity.y = -300 / state_machine.phase
	jumped = true
