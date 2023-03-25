extends State

@onready var player_detector := $"../../Pivot/player_detector"

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("attack")
	owner.velocity.x = 30 * owner.direction
	owner.velocity.y = -200


func physics_update(delta: float) -> void:

	
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	
	if owner.is_on_floor():
		owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
		if owner.velocity.x <= 0:
			state_machine.transition_to("Idle")


