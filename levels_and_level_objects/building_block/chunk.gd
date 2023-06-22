
extends RigidBody2D

@onready var hurtbox := $Hurtbox
@onready var sprite := $Sprite2D
@onready var collision_shape := $CollisionShape2D
@onready var hurtbox_collision_shape := $Hurtbox/CollisionShape2D
@export var drop_pieces: Array[Resource]

var pop_up_duration = 0.2 # Duration of the pop up motion in seconds
var pop_up_velocity = Vector2(0, -200) # Velocity of the pop up motion
var brick_explode_scene = preload("res://vfx/brick_explode.tscn")
var chop_counter := 0
var counter := 0
var last_velocity_x = null
@export var chop_sound: AudioStreamWAV

func _ready():
	hurtbox.area_entered.connect(_chop_up)
	hurtbox_collision_shape.shape.extents.x = sprite.region_rect.size.x/2
	collision_shape.shape.extents.x = sprite.region_rect.size.x/2
	hurtbox_collision_shape.shape.extents.y = sprite.region_rect.size.y/2
	collision_shape.shape.extents.y = sprite.region_rect.size.y/2

func _chop_up(hitbox) -> void:
	SoundPlayer.play_sound_positional(chop_sound, position)
	if hitbox is HitBox:
		chop_counter += 1
		_drop()
		# Check if width or height is smaller than 1 pixel and run destroy function if necessary
		if sprite.region_rect.size.x < 1 or sprite.region_rect.size.y < 1 or chop_counter > 3:
			destroy()
		else:
			# Instantiate particle system when object is chopped
			var brick_explode = brick_explode_scene.instantiate()
			brick_explode.texture = sprite.texture
			brick_explode.modulate = sprite.modulate
			brick_explode.amount = min(sprite.region_rect.size.x, sprite.region_rect.size.y)
			var max_scale = min(sprite.region_rect.size.x, sprite.region_rect.size.y) * 0.02
			brick_explode.process_material.scale_max = max_scale
			brick_explode.restart()
			get_parent().add_child(brick_explode)
			brick_explode.position = position

		if hitbox.execute:
			var new_region_rect = sprite.region_rect
			new_region_rect.size.x /= 2
			sprite.region_rect = new_region_rect
			var col_shape = max(0, sprite.region_rect.size.x / 2 - 2)
			hurtbox_collision_shape.shape.extents.x = col_shape
			collision_shape.shape.extents.x = col_shape
		else:
			var new_region_rect = sprite.region_rect
			new_region_rect.size.y /= 2
			sprite.region_rect = new_region_rect
			var col_shape = max(0, sprite.region_rect.size.y / 2 - 2)
			hurtbox_collision_shape.shape.extents.y = col_shape
			collision_shape.shape.extents.y = col_shape

	# Add pop up motion to simulate impact
	linear_velocity = pop_up_velocity
	await get_tree().create_timer(pop_up_duration).timeout
	linear_velocity = Vector2.ZERO


func destroy():
	queue_free()

func _drop() -> void:
	var probability = 0.5 + (counter * 0.1)
	var position_offset_y = 20
	var velocity_y = -4.0
	var velocity_x1 = 12.0
	var velocity_x2 = -12.0
	
	if randf() < probability:
		var pickup1 = preload("res://pickups/food_pickup.tscn").instantiate()
		var pickup2 = preload("res://pickups/food_pickup.tscn").instantiate()
		var sprite_piece1 = drop_pieces[randi() % drop_pieces.size()]
		var sprite_piece2 = drop_pieces[randi() % drop_pieces.size()]
		
		pickup1.setup(sprite_piece1)
		pickup1.position = global_position
		pickup1.position.y -= position_offset_y
		pickup1.velocity.y = velocity_y
		pickup1.velocity.x = velocity_x1
		
		pickup2.setup(sprite_piece2)
		pickup2.position = global_position
		pickup2.position.y -= position_offset_y
		pickup2.velocity.y = velocity_y
		pickup2.velocity.x = velocity_x2
		
		get_node("/root/").call_deferred("add_child", pickup1)
		get_node("/root/").call_deferred("add_child", pickup2)
		
		counter = 0
	else:
		var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
		var sprite_piece = drop_pieces[randi() % drop_pieces.size()]
		
		pickup.setup(sprite_piece)
		pickup.position = global_position
		pickup.position.y -= position_offset_y
		pickup.velocity.y = velocity_y
		
		if last_velocity_x == null or last_velocity_x == velocity_x1:
			pickup.velocity.x = velocity_x2
			last_velocity_x = velocity_x2
		else:
			pickup.velocity.x = velocity_x1
			last_velocity_x = velocity_x1
		
		get_node("/root/").call_deferred("add_child", pickup)
		
		counter += 1
