extends State

@onready var animation_player := $"../../Pivot/AnimationPlayer"
@onready var effects_player := $"../../Pivot/EffectsPlayer"
@onready var ledge_check_left := $"../../ledge_check_left"
@onready var ledge_check_right := $"../../ledge_check_right"

var flipped := false
var transitioned := false
# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	animation_player.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
#	state_machine.transition_to("Idle")
	owner.velocity.x = owner.speed * owner.direction
	owner.move_and_slide()
	var found_wall = owner.is_on_wall()
	if found_wall or !ledge_check_right.is_colliding() or !ledge_check_left.is_colliding():
		if !flipped:
			owner.direction *= -1
			owner.transform.x.x *= -1
			flipped = true
	else:
		flipped = false
			
#	if not owner.is_on_floor():
#		state_machine.transition_to("enemy_fall")
