extends ParallaxLayer

# Speed of cloud movement
var cloud_speed = 10

func _process(delta):
	# Update the motion offset based on the speed and delta time
	motion_offset.x += cloud_speed * delta
