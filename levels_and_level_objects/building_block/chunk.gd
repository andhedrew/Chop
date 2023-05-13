
extends RigidBody2D

@onready var hurtbox := $Hurtbox
@onready var sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D
@onready var hurtbox_collision_shape := $Hurtbox/CollisionShape2D

var pop_up_duration = 0.2 # Duration of the pop up motion in seconds
var pop_up_velocity = Vector2(0, -200) # Velocity of the pop up motion
var brick_explode_scene = preload("res://vfx/brick_explode.tscn")

func _ready():
	hurtbox.area_entered.connect(_chop_up)

func _chop_up(hitbox) -> void:
	if hitbox is HitBox:
		# Check if width or height is smaller than 1 pixel and run destroy function if necessary
		if sprite.region_rect.size.x < 1 or sprite.region_rect.size.y < 1:
			destroy()
		else:
			# Instantiate particle system when object is chopped
			var brick_explode = brick_explode_scene.instantiate()
			brick_explode.texture = sprite.texture
			brick_explode.modulate = sprite.modulate
			brick_explode.amount = min(sprite.region_rect.size.x, sprite.region_rect.size.y)
			brick_explode.process_material.scale_max = min(sprite.region_rect.size.x, sprite.region_rect.size.y) * 0.02
			brick_explode.restart()
			get_parent().add_child(brick_explode)
			brick_explode.position = position

		if hitbox.execute:
			var new_region_rect = sprite.region_rect
			new_region_rect.size.x /= 2
			sprite.region_rect = new_region_rect
			# Adjust hurtbox and collision shape to match sprite's region_rect
			hurtbox_collision_shape.shape.extents.x = sprite.region_rect.size.x / 2 - 2
			collision_shape.shape.extents.x = sprite.region_rect.size.x / 2 - 2
		else:
			var new_region_rect = sprite.region_rect
			new_region_rect.size.y /= 2
			sprite.region_rect = new_region_rect
			# Adjust hurtbox and collision shape to match sprite's region_rect
			hurtbox_collision_shape.shape.extents.y = sprite.region_rect.size.y / 2 - 2
			collision_shape.shape.extents.y = sprite.region_rect.size.y / 2 - 2

	# Add pop up motion to simulate impact
	linear_velocity = pop_up_velocity
	await get_tree().create_timer(pop_up_duration).timeout
	linear_velocity = Vector2.ZERO


func destroy():
	queue_free()
