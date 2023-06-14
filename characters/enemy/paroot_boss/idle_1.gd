extends State
@onready var player_detector = $"../../Pivot/player_detector"


func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")

func update(_delta) -> void:
	if player_detector.is_colliding():
		state_machine.transition_to("Move")
	
	if Input.is_action_just_pressed("1"):
		state_machine.phase = 2
		state_machine.transition_to("Die")
