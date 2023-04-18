class_name EnemySyphoned
extends State

signal being_syphoned

var shake_pos := 2.0
func enter(_msg := {}) -> void:
	GameEvents.player_done_syphoning.connect(_player_done_syphoning)
	owner.animation_player.play("hurt")
	owner.effects_player.play("syphoning")
	
	

func update(_delta: float) -> void:
	GameEvents.enemy_being_syphoned.emit()

func physics_update(_delta: float) -> void:
	owner.position.x += shake_pos
	shake_pos = -shake_pos
	
func exit() -> void:
	pass

func _player_done_syphoning(_successful_syphon: bool) -> void:
	state_machine.transition_to(state_machine.initial_state_name)
