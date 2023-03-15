extends State

var hitbox_position : Vector2

func enter(msg := {}) -> void:
	hitbox_position = msg[1]
	owner.animation_player.play("hurt")
	owner.effects_player.play("take_damage")
	owner.velocity.x = owner.global_position.x - (hitbox_position.x)
	owner.velocity.y = -150

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	
	owner.velocity.y += Param.GRAVITY * delta
	if owner.is_on_floor():
		owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	
func exit() -> void:
	owner.effects_player.play("RESET")
