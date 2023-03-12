extends CharacterBody2D


const speed = 300.0
const jump_height = -500.0

var facing := Enums.Facing.RIGHT
var default_facing = facing
var facing_previous_frame = facing

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attack: bool
var jump: bool
var dash: bool
var input: Vector2
var state:= Enums.State.IDLE

func _ready():
	pass


func _physics_process(delta):
	get_input()
	_set_debug_labels()
	handle_facing()


func _set_debug_labels() -> void:
	match facing:
		Enums.Facing.LEFT: $Facing.text = "left"
		Enums.Facing.RIGHT: $Facing.text = "right"
	
	$State.text = $StateMachine.state.name


func get_input() -> void:
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	jump =  Input.is_action_just_pressed("jump")
	dash = Input.is_action_pressed("dash")


func handle_facing() -> void:
	if input.y == 0:
		if input.x > 0:
			facing = Enums.Facing.RIGHT
			default_facing = facing
		elif input.x < 0:
			facing = Enums.Facing.LEFT
			default_facing = facing
		else:
			facing = default_facing
	elif input.y < 0:
		facing = Enums.Facing.UP
	elif input.y > 0:
		facing = Enums.Facing.DOWN
	if facing_previous_frame != facing:
		GameEvents.player_changed_facing.emit(facing)
	facing_previous_frame = facing
	if input.x > 0:
		$Pivot.transform.x.x = 1
	elif input.x < 0:
		$Pivot.transform.x.x = -1
