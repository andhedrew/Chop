@tool

extends Node2D

var leg_state := "Walk"
@export var start_point := 0.0
@export var back_leg := false
@onready var lower_leg_sprite := $Path2D/leg_lower/Sprite2D

var x_shift := 50

@export var leg_movement := 0.0
var leg_move_speed :=  0.061
# Called when the node enters the scene tree for the first time.
func _ready():
	$Path2D/leg_lower.progress_ratio = start_point
	if back_leg:
#		$Path2D/leg_lower/Hitbox.set_deferred("monitorable", false)
		$Path2D/leg_lower/Shield.set_deferred("monitorable", false)
	else:
#		$Path2D/leg_lower/Hitbox.set_deferred("monitorable", true)
		$Path2D/leg_lower/Shield.set_deferred("monitorable", true)
	leg_movement = start_point
	if start_point < 0.5:
		position.x -= x_shift * start_point
	else:
		position.x += x_shift * start_point


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match leg_state:
		"Walk":

			if leg_movement < 0.49 and leg_movement > 0.05:
				$Path2D/leg_lower/Sprite2D.frame = 1
#				lower_leg_sprite.frame = 1
				leg_move_speed = lerp(leg_move_speed, 0.061, 0.5)
			else:
				$Path2D/leg_lower/Sprite2D.frame = 0
#				lower_leg_sprite.frame = 0
				leg_move_speed = lerp(leg_move_speed, 0.25, 0.05)

			leg_movement += delta * leg_move_speed

			if leg_movement > 1.0:
				leg_movement = 0.0
			$Path2D/leg_lower.progress_ratio = leg_movement
		"Attack":
			$Path2D/leg_lower.frame = 2
		"Chopped":
			pass

