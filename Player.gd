extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var facing := Enums.Facing.RIGHT
var default_facing = facing
var facing_previous_frame = facing

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attack: bool
var jump: bool
var dash: bool
var input: Vector2

func _physics_process(delta):
	get_input()
	
	if not is_on_floor():
		velocity.y += gravity * delta

	if jump and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if input.x:
		velocity.x = input.x * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	
	_set_debug_labels()
	handle_facing()
	move_and_slide()


func _set_debug_labels() -> void:
	match facing:
		Enums.Facing.LEFT: $Facing.text = "left"
		Enums.Facing.RIGHT: $Facing.text = "right"
	


func get_input() -> void:
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	jump =  Input.is_action_pressed("jump")
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
		GameEvents.emit_signal("player_changed_facing", facing)
	facing_previous_frame = facing
	if input.x > 0:
		transform.x.x = 1
	elif input.x < 0:
		transform.x.x = -1
