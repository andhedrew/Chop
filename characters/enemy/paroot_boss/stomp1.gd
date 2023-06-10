extends State


var jumped := false

func enter(_msg := {}) -> void:
	owner.animation_player.play("stomp")
	
	


func update(delta):
	owner.move_and_slide()
	if jumped:
		owner.velocity.y += Param.GRAVITY * delta
	else:
		owner.velocity.x = lerp(owner.velocity.x, 0.0, 0.2)
	
	if jumped and owner.is_on_floor():
		jumped = false
		GameEvents.boss_stomped.emit()
		await get_tree().create_timer(0.5).timeout
		state_machine.transition_to("Move")


func add_velocity() -> void:
	owner.velocity.y = -150
	jumped = true
