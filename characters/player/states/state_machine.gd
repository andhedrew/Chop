class_name PlayerStateMachine
extends Node


# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var initial_state := NodePath()

# The current active state. At the start of the game, we get the `initial_state`.
@onready var state: State = get_node(initial_state)


func _ready() -> void:
	await owner.ready

	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)


# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	if not has_node(target_state_name):
		return

	state.exit()
	state = get_node(target_state_name)
	state.enter(msg)
	GameEvents.player_changed_state.emit(state.name) 
