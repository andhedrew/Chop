@tool

extends Node2D


@export var leg_movement := 0.0
var leg_move_speed :=  0.061
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leg_movement > 0.46 and leg_movement < 0.87:
		leg_move_speed = lerp(leg_move_speed, 0.061, 0.5)
	else:
		leg_move_speed = lerp(leg_move_speed, 0.5, 0.05)
	
	leg_movement += delta * leg_move_speed
		
	if leg_movement > 1.0:
		leg_movement = 0.0
	$Path2D/leg_lower.progress_ratio = leg_movement
	
