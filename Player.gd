# Wilmer Dermeet
extends CharacterBody2D
class_name Player

@export var camera : Camera2D 

const max_speed := 120
const acceleration := 9
const acceleration_in_air := 5
const jump_height = -200.0

var invulnerable := false
var health := 10

var facing := Enums.Facing.RIGHT
var looking := Enums.Looking.FORWARD
var default_facing = facing
var facing_last_frame = facing

var attack: bool
var jump: bool
var dash: bool
var input: Vector2
var state:= "Idle"
var state_last_frame := state

@onready var hurtbox := $Hurtbox
@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer

func _ready():
	hurtbox.area_entered.connect(_hurtbox_on_area_entered)


func _physics_process(_delta):
	get_input()
	state = $StateMachine.state.name
	_set_debug_labels()
	handle_facing()
	state_last_frame = state


func _set_debug_labels() -> void:
	match facing:
		Enums.Facing.LEFT: $Facing.text = "left"
		Enums.Facing.RIGHT: $Facing.text = "right"
	
	$State.text = state


func get_input() -> void:
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	jump =  Input.is_action_just_pressed("jump")
	dash = Input.is_action_pressed("dash")


func handle_facing() -> void:
	if state == "Attack" or state == "Execute" or state == "Hurt": 
		return
	if input.y == 0:
		looking = Enums.Looking.FORWARD
		if input.x > 0:
			facing = Enums.Facing.RIGHT
			default_facing = facing
		elif input.x < 0:
			facing = Enums.Facing.LEFT
			default_facing = facing
		else:
			facing = default_facing
	elif input.y < 0:
		looking = Enums.Looking.UP
	elif input.y > 0:
		looking = Enums.Looking.DOWN
	if facing_last_frame != facing:
		GameEvents.player_changed_facing.emit(facing)
	facing_last_frame = facing
	
	if input.x > 0:
		$Pivot.transform.x.x = 1
	elif input.x < 0:
		$Pivot.transform.x.x = -1


func _hurtbox_on_area_entered(hitbox) -> void:
	if !invulnerable and hitbox is HitBox:
		var hitbox_position : Dictionary = {1:hitbox.global_position}
		$StateMachine.transition_to("Hurt", hitbox_position)
		take_damage(hitbox.damage)


func take_damage(damage) -> void:
	
	health -= damage
	GameEvents.player_health_changed.emit(health)
