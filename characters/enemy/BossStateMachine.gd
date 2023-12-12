extends Node

@export var initial_state := NodePath()
@onready var state: State = get_node(initial_state)
@onready var initial_state_name := str(get_node(initial_state))
var previous_state : String
var state_timer := 0.0
var invulnerable_timer := 0.0

var phase := 1

func _ready() -> void:
	print_debug("state:" + str(initial_state_name))

	await owner.ready
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	for child in get_children():
		child.state_machine = self
	state.enter()
	state_timer = 0


func _process(delta: float) -> void:
	owner.phase = phase
	if !owner.cutscene_running:
		state.update(delta)


func _physics_process(delta: float) -> void:
	if !owner.cutscene_running:
		state.physics_update(delta)
	state_timer += delta
	
	if invulnerable_timer > 0.0:
		owner.invulnerable = true
		invulnerable_timer -= delta
	else:
		owner.invulnerable = false
		invulnerable_timer = 0.0


func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
		target_state_name = target_state_name + str(phase)
		if not has_node(target_state_name):
			return
		previous_state = state.name
		state.exit()
		state = get_node(target_state_name)
		print_debug(str(owner.name)+ ": " + str(previous_state) + " -> " + str(state))
		state.enter(msg)
		state_timer = 0


func _on_cutscene_start() -> void:
	transition_to("Cutscene")


