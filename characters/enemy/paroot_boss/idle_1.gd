extends State

func _ready():
	$"../../Pivot/Shield".area_entered.connect(_when_player_attacks)


func enter(_msg := {}) -> void:
	print_debug("start _enter func")
	owner.animation_player.play("idle")
	print_debug("set up state")



func _when_player_attacks(_area) -> void:
	print_debug("move")
	state_machine.transition_to("Move")
