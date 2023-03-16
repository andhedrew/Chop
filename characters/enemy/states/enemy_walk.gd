extends State

@onready var ledge_check_left := $"../../ledge_check_left"
@onready var ledge_check_right := $"../../ledge_check_right"

var flipping := false

var transitioned := false
# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_update(_delta: float) -> void:
	owner.velocity.x = owner.speed * owner.direction
	owner.move_and_slide()
	var found_wall = owner.is_on_wall()
	if found_wall or !ledge_check_right.is_colliding() or !ledge_check_left.is_colliding():
		if !flipping:
			flipping = true
			owner.switch_facing()
	
	if !found_wall and ledge_check_right.is_colliding() and ledge_check_left.is_colliding():
		flipping = false
	

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")


func exit() -> void:
	flipping = false
