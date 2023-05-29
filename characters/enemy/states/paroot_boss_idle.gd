class_name  ParootBossIdle
extends WalkerIdle

var phase = 2

func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")


func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
	
	if phase == 1:
		if state_machine.state_timer > 0.5:
				state_machine.transition_to("Attack")
	elif phase == 2:
		state_machine.transition_to("Attack")
