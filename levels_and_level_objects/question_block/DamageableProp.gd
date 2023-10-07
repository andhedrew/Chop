extends ExplodingProp


@export var chopped_sprite: Texture2D

func _destroy() -> void:
	GameEvents.new_vfx.emit("res://vfx/slice.tscn", global_position)

	var explode = particle_scene.instantiate()
	explode.restart()
	explode.texture = particle_texture
	var width : int = particle_texture.get_width() / 16
	explode.material.set_particles_anim_h_frames(width)
	get_parent().add_child(explode)
	explode.position = position

	# Get the shape resource from the CollisionShape2D node
	var shape = collision_shape.shape
	# Check if the shape is a RectangleShape2D
	if shape is RectangleShape2D:
		# Calculate the area of the RectangleShape2D
		var area = shape.extents.x * 2 * shape.extents.y * 2
		# Calculate the number of particles based on the area
		var num_particles = int(area / (32 * 32) * 16)
		# Set the amount property of the GPUParticles2D
		explode.amount = num_particles
	# Set the emission shape to box
	explode.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	# Set the box extents to match the width and height of the Sprite2D
	var new_width = collision_shape.shape.size.x
	var new_height = collision_shape.shape.size.y
	explode.process_material.emission_box_extents = Vector3(new_width, new_height, 0)
	$Sprite2D.texture = chopped_sprite
	
