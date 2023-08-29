extends State



func enter(_msg := {}) -> void:
	$"../../PlayerDetector".body_entered.connect(_on_body_entered)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	if state_machine.state_timer > 5:
		pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass


func _on_body_entered(body) -> void:
	if body is Player:
		state_machine.transition_to("Idle")
