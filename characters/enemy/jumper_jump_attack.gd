extends State

@onready var player_detector := $"../../Pivot/player_detector"
@export var jump_x_speed : int = 30
@export var jump_y_speed : int = 200


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	jump_y_speed = int(randf_range(200, 230))
	jump_x_speed = int(randf_range(30, 45))
	owner.animation_player.play("attack")
	jump_x_speed *= owner.direction
	jump_y_speed *= -1
	owner.velocity.x = jump_x_speed
	owner.velocity.y = jump_y_speed


func physics_update(delta: float) -> void:	
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	
	if owner.is_on_floor():
		owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
		if owner.velocity.x <= 0:
			state_machine.transition_to("Idle")
	
	if owner.velocity.y > 0:
		owner.animation_player.play("fall")
	else:
		owner.animation_player.play("attack")


