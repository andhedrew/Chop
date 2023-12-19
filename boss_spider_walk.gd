extends State

var speed := 85
var attack_timer := randf_range(4.0, 6.0)

func enter(_msg := {}) -> void:
	attack_timer = randf_range(4.0, 6.0)

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	owner.position.x += speed*delta
	attack_timer -= delta
#	if attack_timer < 0 and owner.seeing_player:
#		state_machine.transition_to("Attack")

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass
