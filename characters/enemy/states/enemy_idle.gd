extends State

@onready var ledge_left := $"../../adjacent_ledge_check_left"
@onready var ledge_right := $"../../adjacent_ledge_check_right"
@onready var wall_left := $"../../wall_check_left"
@onready var wall_right := $"../../wall_check_right"

var transitioned := false
var timer: Timer

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	
	var left_blocked = !ledge_left.is_colliding() or wall_left.is_colliding()
	var right_blocked = !ledge_right.is_colliding() or wall_right.is_colliding()
		
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()

	if timer.is_stopped() and !(left_blocked and right_blocked):
		timer.queue_free()
		state_machine.transition_to("Walk")

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
