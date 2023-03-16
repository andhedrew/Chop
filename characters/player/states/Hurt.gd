extends State

var hitbox_position : Vector2
var hurt_timer: SceneTreeTimer
func enter(msg := {}) -> void:
	hitbox_position = msg[1]
	owner.animation_player.play("hurt")
	owner.effects_player.play("fx/take_damage")
	owner.velocity.y = -150
	owner.velocity.x = (owner.global_position.x - hitbox_position.x)*12
	hurt_timer = get_tree().create_timer(0.5)
	hurt_timer.timeout.connect(_hurt_timer_done)
	

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, 0.05)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()


func exit() -> void:
	owner.effects_player.play("RESET")


func _hurt_timer_done() -> void:
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Fall")
