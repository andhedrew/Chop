@tool
extends Node2D

# Declare your variable with a setter function
@export_range(0, 49) var sprite_frame := 0

func _process(delta):
	$Tree.frame = sprite_frame


