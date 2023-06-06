extends State

func enter(_msg := {}) -> void:
	print_debug("start _enter func")
	owner.animation_player.play("idle")
	$"../../Pivot/Shield".area_entered.connect(_when_player_attacks)
	print_debug("set up state")



func _when_player_attacks(area) -> void:
	print_debug("move")
	state_machine.transition_to("Move")
