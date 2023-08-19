extends State

@onready var player_detector := $"../../Pivot/player_detector"
var path

var speed = owner.speed * 0.001
var target_speed = speed

func _ready() -> void:
	path = owner.get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("walk")
	path.set_rotates(false)

func physics_update(_delta: float) -> void:

	
	speed = lerp(speed, target_speed, 0.1)
	
	path.progress_ratio += speed

	if player_detector.is_colliding():
		var detected_object = player_detector.get_collider()
		if detected_object is Player:
			state_machine.transition_to("Attack")
