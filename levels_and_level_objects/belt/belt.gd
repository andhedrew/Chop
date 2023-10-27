extends StaticBody2D

@export var speed = 100

var path

var flipped := false
var patrol_speed := 0.01
var target_speed := patrol_speed

func _ready() -> void:
	constant_linear_velocity.x = speed
	path = get_parent() as PathFollow2D
	path.set_rotates(false)



func _physics_process(_delta: float) -> void:
	if path.progress_ratio >= 0.95 and !flipped:
		flipped = true
		target_speed = -target_speed
	elif path.progress_ratio <= 0.05 and flipped:
		flipped = false
		target_speed = -target_speed
	patrol_speed = lerp(patrol_speed, target_speed, 0.1)
	
	path.progress_ratio += patrol_speed
