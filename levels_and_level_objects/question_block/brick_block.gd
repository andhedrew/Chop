extends StaticBody2D

var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")
@export var particle_texture: Texture
@onready var hurtbox := $Hurtbox
@onready var my_sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D

func _ready():
	hurtbox.area_entered.connect(_take_damage)

func _take_damage(area):
	if area is HitBox:
		_destroy()

func _destroy() -> void:
	var slice = slice_scene.instantiate()
	get_parent().add_child(slice)
	slice.position = position

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
		var num_particles = int(area / (32 * 32) * 32)
		# Set the amount property of the GPUParticles2D
		explode.amount = num_particles
		print_debug(str(num_particles))
	# Set the emission shape to box
	explode.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	# Set the box extents to match the width and height of the Sprite2D
	var new_width = collision_shape.shape.size.x
	var new_height = collision_shape.shape.size.y
	explode.process_material.emission_box_extents = Vector3(new_width, new_height, 0)

	queue_free()
