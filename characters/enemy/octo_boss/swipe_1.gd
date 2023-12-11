extends State


func enter(msg := {}) -> void:
	await get_tree().create_timer(0.3).timeout
	match msg["arm"]:
		"left":
			$"../../AnimationPlayer".play("swipe_arm_left")
		"right":
			$"../../AnimationPlayer".play("swipe_arm_right")
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("Idle")
		

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass

