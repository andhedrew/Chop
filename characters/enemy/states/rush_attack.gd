extends State

@onready var ledge_check_left := $"../../ledge_check_left"
@onready var ledge_check_right := $"../../ledge_check_right"
@onready var ledge_left := $"../../adjacent_ledge_check_left"
@onready var ledge_right := $"../../adjacent_ledge_check_right"
@onready var wall_left := $"../../wall_check_left"
@onready var wall_right := $"../../wall_check_right"
@onready var player_detector := $"../../Pivot/player_detector"


var flipping := false
var transitioned := false
var state_timer:= 29
var wait_time := 2

@export var speed_boost := 3.5
var attacking := false

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	attacking = false
	owner.animation_player.play("get_angry")
	SoundPlayer.play_sound_positional("grunt", owner.position)
	await $"../../Pivot/AnimationPlayer".animation_finished
	attacking = true
	owner.animation_player.play("attack")


func physics_update(_delta: float) -> void:
	var left_blocked = !ledge_left.is_colliding() or wall_left.is_colliding()
	var right_blocked = !ledge_right.is_colliding() or wall_right.is_colliding()
	
	if state_machine.state_timer > 8.0 or (left_blocked and right_blocked):
			state_machine.transition_to("Idle")
			
	
	if attacking:
		owner.velocity.x = (owner.speed * speed_boost) * owner.direction
	owner.move_and_slide()
	
	var found_hazard = wall_left.is_colliding() or wall_right.is_colliding()
	if found_hazard or !ledge_check_right.is_colliding() or !ledge_check_left.is_colliding():
		if !flipping:
			flipping = true
			owner.switch_facing()
	
	if !found_hazard and ledge_check_right.is_colliding() and ledge_check_left.is_colliding():
		flipping = false

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")


func exit() -> void:
	flipping = false
