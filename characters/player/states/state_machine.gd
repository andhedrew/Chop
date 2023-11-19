class_name StateMachine
extends Node

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)
@onready var initial_state_name := str(get_node(initial_state))
var previous_state : String
var state_timer := 0.0
var invulnerable_timer := 0.0
var execute_timer := 0.0
var current_state_name := ""

func _ready() -> void:
	await owner.ready
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	for child in get_children():
		child.state_machine = self
	state.enter()
	state_timer = 0


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)
	owner.current_state = current_state_name
	if owner == Player:
		if owner.execute_disabled == true:
			execute_timer += 1.0
			if execute_timer >= 60.0:
				owner.execute_disabled = false
				execute_timer = 0.0


func _physics_process(delta: float) -> void:
	state.physics_update(delta)
	state_timer += delta
	if invulnerable_timer > 0:
		owner.invulnerable = true
		invulnerable_timer -= delta
	else:
		owner.invulnerable = false


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
		if not has_node(target_state_name):
			return

		previous_state = state.name
		state.exit()
		GameEvents.player_changed_state.emit(target_state_name, previous_state)
		state = get_node(target_state_name)
		current_state_name = target_state_name
		state.enter(msg)
		state_timer = 0


func _on_cutscene_start() -> void:
	transition_to("Cutscene")


func _on_cutscene_end() -> void:
	transition_to("Idle")
