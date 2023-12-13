extends State

@onready var animation_player = $"../../AnimationPlayer"
func enter(_msg := {}) -> void:
	GameEvents.cutscene_started.emit()
	await get_tree().create_timer(0.5).timeout
	animation_player.play("transition")
	await animation_player.animation_finished
	$"..".phase = 2
	$"../../CollisionShape2D".disabled = false
	await get_tree().create_timer(0.5).timeout
	GameEvents.cutscene_ended.emit()
	state_machine.transition_to("Idle")
