extends State

var leave_inactive := false

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
	if !leave_inactive:
		if body is Player:
			leave_inactive = true
			GameEvents.start_octo_battle.emit()
			state_machine.transition_to("Idle")
