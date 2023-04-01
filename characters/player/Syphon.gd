extends State

@onready var animation_player := $"../../Pivot/AnimationPlayer"

var syphon_timer := 0.0
var syphon_time := 1.0

func enter(_msg := {}) -> void:
	GameEvents.player_started_syphoning.emit(owner.global_position)
	syphon_timer = 0.0


func physics_update(delta: float) -> void:
	
	syphon_timer += delta
	if syphon_timer >= syphon_time:
		GameEvents.player_done_syphoning.emit(true)
		if owner.is_on_floor():
			state_machine.transition_to("Idle")
		else: 
			state_machine.transition_to("Fall")
	if Input.is_action_just_released("syphon") and owner.is_on_floor():
		state_machine.transition_to("Idle")
	elif Input.is_action_just_released("syphon"): 
		state_machine.transition_to("Fall")


func exit() -> void:
	GameEvents.player_done_syphoning.emit(false)
