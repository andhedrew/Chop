extends State

@onready var player_detector := $"../../Pivot/player_detector"
var start_position 
var end_position

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	$"../../Hurtbox".monitoring = true
	start_position = owner.position.y
	end_position = owner.position.y - 20
	owner.animation_player.play("attack")

func physics_update(delta: float) -> void:
	if owner.position.y > end_position:
		owner.position.y = lerp(owner.position.y, end_position, 0.2)
	else:
		state_machine.transition_to("Idle")


