extends State

@onready var player_detector := $"../../Pivot/player_detector"
var path

var flipped := false
var speed := -0.03
var target_speed := speed

func _ready() -> void:
	if owner.facing == Enums.Facing.RIGHT:
		flipped = true
	else:
		flipped = false
		
	path = owner.get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("attack")
	path.set_rotates(false)

func physics_update(_delta: float) -> void:
	if path.progress_ratio >= 0.95 and !flipped:
		flipped = true
		target_speed = -target_speed
		owner.switch_facing()
	elif path.progress_ratio <= 0.05 and flipped:
		flipped = false
		target_speed = -target_speed
		owner.switch_facing()
	
	speed = lerp(speed, target_speed, 0.1)
	
	path.progress_ratio += speed

	if state_machine.state_timer >= 3.0:
		state_machine.transition_to("Move")
