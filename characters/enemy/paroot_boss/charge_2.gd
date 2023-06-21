extends State

@onready var wall_left := $"../../wall_check_left"
@onready var wall_right := $"../../wall_check_right"
@onready var player_detector := $"../../Pivot/player_detector"


var flipping := false
var transitioned := false
var wait_time := 2
var timer: Timer
var speed_mult := 0.0
# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	
	owner.animation_player.play("charge")


func update(_delta: float) -> void:

	speed_mult = lerp(speed_mult, 3.0, 0.2)
	owner.velocity.x = (owner.speed * speed_mult) * owner.direction
	owner.move_and_slide()
	
	var colliding = wall_left.is_colliding() or wall_right.is_colliding()
	if colliding:
		if !flipping:
			SoundPlayer.play_sound_positional("impact_with_dirt", owner.global_position)
			flipping = true
			owner.switch_facing()
			GameEvents.boss_hit_wall.emit()
	
	if !colliding:
		flipping = false

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")

	if state_machine.state_timer > 7.0:
		state_machine.transition_to("Stomp")


func exit() -> void:
	flipping = false
