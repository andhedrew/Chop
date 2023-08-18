extends EnemyHurt
var start_position 
var end_position

func enter(msg := {}) -> void:
	super.enter()
	hitbox_position = msg["position"]
	start_position = owner.position.y
	end_position = owner.position.y + 20



func physics_update(delta: float) -> void:
	if owner.position.y < end_position:
		owner.position.y = lerp(owner.position.y, end_position, 0.2)
	else:
		state_machine.transition_to("Idle")

