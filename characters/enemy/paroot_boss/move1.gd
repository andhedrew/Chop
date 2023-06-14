extends State


@onready var wall_left := $"../../wall_check_left"
@onready var wall_right := $"../../wall_check_right"
@onready var player_detector := $"../../Pivot/player_detector"


var flipping := false
var transitioned := false
var time := 3.5
var timer := 0.0

var plants_planted := 0

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("walk1")


func physics_update(delta: float) -> void:
	timer += delta
	if state_machine.phase == 2:
		time = 2.0
	if timer > time:
		plants_planted += 1
		if plants_planted > 2:
			plants_planted = 0
			state_machine.transition_to("Stomp")
		var spawn := preload("res://characters/enemy/paroot_plant/paroot_plant.tscn").instantiate()
		spawn.position = owner.global_position
		get_node("/root/World").add_child(spawn)
		timer = 0.0
	
	owner.velocity.x = owner.speed * owner.direction
	owner.move_and_slide()
	
	var collided = wall_left.is_colliding() or wall_right.is_colliding()

	if collided:
		if !flipping:
			flipping = true
			owner.switch_facing()

	if !collided:
		flipping = false

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
	
	if player_detector.is_colliding() and owner.is_on_floor() and state_machine.state_timer > 0.1:
		var detected_object = player_detector.get_collider()
		if detected_object is Player:
			state_machine.transition_to("Attack")


func exit() -> void:
	flipping = false
