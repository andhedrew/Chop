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
var time := 3.0
var timer := 0.0

var plants_planted := 0

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("walk1")


func physics_update(delta: float) -> void:
	timer += delta
	if timer > time:
		plants_planted += 1
		if plants_planted > 2:
			state_machine.transition_to("Stomp")
		var spawn := preload("res://characters/enemy/paroot_plant/paroot_plant.tscn").instantiate()
		spawn.position = owner.global_position
		get_node("/root/").add_child(spawn)
		timer = 0.0
	
	var left_blocked = !ledge_left.is_colliding() or wall_left.is_colliding()
	var right_blocked = !ledge_right.is_colliding() or wall_right.is_colliding()
	
	owner.velocity.x = owner.speed * owner.direction
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
	
	if player_detector.is_colliding() and owner.is_on_floor():
		var detected_object = player_detector.get_collider()
		if detected_object is Player:
			state_machine.transition_to("Attack")


func exit() -> void:
	flipping = false
