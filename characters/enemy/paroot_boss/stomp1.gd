extends State


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	GameEvents.boss_stomped.emit()
	GameEvents.boss_stomped.emit()
	if randf() > 0.5:
		GameEvents.boss_stomped.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta):
	state_machine.transition_to("Move")
