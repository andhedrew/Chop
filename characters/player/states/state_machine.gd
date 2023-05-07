

class_name StateMachine
extends Node

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)
@onready var initial_state_name := str(get_node(initial_state))
var previous_state : String

func _ready() -> void:
	await owner.ready
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
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


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
		if not has_node(target_state_name):
			return

		previous_state = state.name
		state.exit()
		GameEvents.player_changed_state.emit(target_state_name, previous_state)
		state = get_node(target_state_name)
		state.enter(msg)


func _on_cutscene_start() -> void:
	transition_to("Cutscene")


func _on_cutscene_end() -> void:
	transition_to("Idle")
