class_name WalkerWalk
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
var timer: Timer

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("walk")



func physics_update(_delta: float) -> void:
	var _left_blocked = !ledge_left.is_colliding() or wall_left.is_colliding()
	var _right_blocked = !ledge_right.is_colliding() or wall_right.is_colliding()
	
	if abs(owner.velocity.x + owner.speed * owner.direction) <= owner.max_x_speed:
		owner.velocity.x += (owner.speed * owner.direction) + owner.belt_speed
	else:
		if owner.velocity.x < 0:
			owner.velocity.x = -owner.max_x_speed + owner.belt_speed
		else:
			owner.velocity.x = owner.max_x_speed + owner.belt_speed
	
	
	
	var found_wall = wall_left.is_colliding() or wall_right.is_colliding()
	
	if found_wall or !ledge_check_right.is_colliding() or !ledge_check_left.is_colliding():
		if !flipping:
			flipping = true
			owner.switch_facing()
	
	
	if !found_wall and ledge_check_right.is_colliding() and ledge_check_left.is_colliding():
		flipping = false
	
	owner.move_and_slide()

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
	
	if player_detector.is_colliding() and owner.is_on_floor():
		var detected_object = player_detector.get_collider()
		if detected_object is Player:
			state_machine.transition_to("Attack")


func exit() -> void:
	flipping = false
