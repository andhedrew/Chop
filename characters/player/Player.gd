# Wilmer Dermeet
extends CharacterBody2D
class_name Player

@export var camera : Camera2D 

const max_speed := 120
const acceleration := 9
const acceleration_in_air := 5
const jump_height = -200.0

var invulnerable := false
var max_health := 6
var health := max_health


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

var bag := []
var bag_capacity := 15
var torch_charges := 3
var max_torch_charges := torch_charges
var charge_time := 2.0
var charge_timer := charge_time
var execute_disabled := false

var set_ui := false

@onready var hurtbox := $Hurtbox
@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer


func _ready():
	hurtbox.area_entered.connect(_hurtbox_on_area_entered)
	GameEvents.enemy_took_damage.connect(_on_enemy_taking_damage)



func _physics_process(delta):
	if !set_ui:
		set_ui = true
		GameEvents.player_health_changed.emit(health, max_health)
		GameEvents.bag_capacity_changed.emit(bag_capacity)
	
	get_input()
	state = $StateMachine.state.name
	_set_debug_labels()
	handle_facing()
	state_last_frame = state
	
	if torch_charges < max_torch_charges:
		if is_on_floor():
			charge_time -= 1*delta
			if charge_time < 0:
				torch_charges += 1
				charge_time = charge_timer
				GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)


func _set_debug_labels() -> void:
	match facing:
		Enums.Facing.LEFT: $Facing.text = "Facing: left"
		Enums.Facing.RIGHT: $Facing.text = "Facing: right"
	
	$State.text = state
	
	match looking:
		Enums.Looking.UP: $Looking.text = "Looking: up"
		Enums.Looking.DOWN: $Looking.text = "Looking: down"
		Enums.Looking.FORWARD: $Looking.text = "Looking: forward"


func get_input() -> void:
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	jump =  Input.is_action_just_pressed("jump")
	dash = Input.is_action_pressed("dash")


func handle_facing() -> void:
	if state == "Attack" or state == "Execute" or state == "Hurt" or state == "Cutscene": 
		return
	if input.x > 0:
		facing = Enums.Facing.RIGHT
		default_facing = facing
	elif input.x < 0:
		facing = Enums.Facing.LEFT
		default_facing = facing
		
	if input.y == 0:
		looking = Enums.Looking.FORWARD
	elif input.y < 0:
		looking = Enums.Looking.UP
		$Pivot/BulletSpawn.position = Vector2(0, -20)
	elif input.y > 0:
		looking = Enums.Looking.DOWN
	if facing_last_frame != facing:
		GameEvents.player_changed_facing.emit(facing)
	facing_last_frame = facing
	
	if input.x > 0:
		$Pivot.transform.x.x = 1
	elif input.x < 0:
		$Pivot.transform.x.x = -1
	
	if Input.is_action_pressed("down") and !is_on_floor():
		$Pivot/BulletSpawn.position = Vector2(30, 20)
	else: 
		$Pivot/BulletSpawn.position = Vector2(10, 0)

func _hurtbox_on_area_entered(hitbox) -> void:
	if !invulnerable and hitbox is HitBox:
		var hitbox_position : Dictionary = {1:hitbox.global_position}
		$StateMachine.transition_to("Hurt", hitbox_position)
		take_damage(hitbox.damage)


func take_damage(damage) -> void:
	health -= damage
	GameEvents.player_health_changed.emit(health, max_health)


func _on_enemy_taking_damage() -> void:
	if torch_charges < max_torch_charges:
		torch_charges += 1
		GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)
