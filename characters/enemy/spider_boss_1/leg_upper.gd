@tool
extends Node2D


@onready var lower_leg := $"../Path2D/leg_lower"
var default_distance := 360.0
var default_scale := 1.0


func _ready():
	default_distance = 360.0
	default_scale = 1.0
	
	
func _process(delta):
	point_at(lower_leg.position)
	adjust_scale(lower_leg.position)

func point_at(target_position: Vector2):
	# Calculate the angle to the target
	var direction: Vector2 = target_position - position
	rotation = direction.angle() + 1.55

#
func adjust_scale(target_position: Vector2):
	# Calculate the current distance to the target
	default_distance = 360.0
	default_scale = 1.0
	var current_distance := position.distance_to(target_position)
#	print_debug("current_distance: " + str(current_distance))
#	print_debug("default_distance: " + str(default_distance))
	# Check if the current distance is zero to avoid division by zero
	if current_distance == default_distance:
		$joint.scale.y = default_scale
	else:
		# Adjust the y scale based on the distance
		var scale_factor := current_distance / default_distance
#		print_debug("scale_factor: " + str(scale_factor))
		# Apply the scale factor to the y scale
		$joint.scale.y = default_scale * scale_factor
