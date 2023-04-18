extends State

@onready var animation_player := $"../../Pivot/AnimationPlayer"

var syphon_timer := 0.0
var syphon_time := 1.0
var baddies_being_syphoned := false
var signal_setup := false

func enter(_msg := {}) -> void:
	GameEvents.player_started_syphoning.emit(owner.global_position)
	if !signal_setup:
		GameEvents.enemy_being_syphoned.connect(_on_enemy_syphoned)
		signal_setup = true
	syphon_timer = 0.0
	baddies_being_syphoned = false


func physics_update(delta: float) -> void:
	
	syphon_timer += delta
	if syphon_timer >= syphon_time:
		if baddies_being_syphoned:
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


func _on_enemy_syphoned() -> void:
	baddies_being_syphoned = true
