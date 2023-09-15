extends State
@onready var player_detector = $"../../Pivot/player_detector"


func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")

func update(_delta) -> void:
	if player_detector.is_colliding():
		state_machine.transition_to("Attack")
