@tool
extends RigidBody2D

@onready var hurtbox := $Hurtbox
@onready var sprite := $Sprite2D
@onready var damage_sprite := $Sprite2D2
@onready var collision_shape := $CollisionShape2D
@onready var hurtbox_collision_shape := $Hurtbox/CollisionShape2D

@export var particle_texture: Texture
@export var particle_texture_width: int = 16
var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")

@export var texture: Texture2D = preload("res://levels_and_level_objects/dirt_block/dirt_block.png")
@export var damage_texture: Texture2D = preload("res://levels_and_level_objects/dirt_block/dirt_block.png")
@export var drop_pieces: Array[Resource]
@export var take_damage_sound: AudioStreamWAV

@export var pop_up := true
var pop_up_duration = 0.2 # Duration of the pop up motion in seconds
var pop_up_velocity = Vector2(0, -200) # Velocity of the pop up motion
var brick_explode_scene = preload("res://vfx/brick_explode.tscn")
var chop_counter := 0
var counter := 0
var last_velocity_x = null
@export var damage_sprite_margin := 4
var set_collision := false
var original_position := Vector2.ZERO
@export var chop_sound: AudioStreamWAV


func _ready():
	original_position = position
	hurtbox.area_entered.connect(_chop_up)
	set_collision = false
	damage_sprite.z_index = SortLayer.FOREGROUND
	
	collision_shape.shape = RectangleShape2D.new()
	hurtbox_collision_shape.shape = RectangleShape2D.new()




func _process(delta):
	if sprite.texture != texture:
		sprite.texture = texture
		var size = Vector2(
			sprite.texture.get_width(), 
			sprite.texture.get_height()
			)
		_set_sprite_region(sprite, size)
		set_collision = false
		
	
	if damage_sprite.texture != damage_texture:
		damage_sprite.texture = damage_texture
		var size = Vector2(
			damage_sprite.texture.get_width(), 
			damage_sprite.texture.get_height()
			)
		_set_sprite_region(damage_sprite, size)
	
	
	if set_collision == false:
		var size = Vector2(
			sprite.texture.get_width(), 
			sprite.texture.get_height()
			)
		hurtbox_collision_shape.shape.extents = size * 0.5
		hurtbox_collision_shape.position.y = -sprite.texture.get_height() * 0.5
		collision_shape.shape.extents = size * 0.5
		collision_shape.position.y = -sprite.texture.get_height() * 0.5
		set_collision = true
	
	
		
	

func _set_sprite_region(sprite_to_set, size: Vector2) -> void:
	sprite_to_set.set_region_rect(Rect2(0,0,size.x, size.y))
	sprite_to_set.position.y = -sprite_to_set.texture.get_height() * 0.5


func _chop_up(hitbox) -> void:
	SoundPlayer.play_sound_positional(chop_sound, position)
	if hitbox is HitBox:
		chop_counter += 1
		if drop_pieces:
			_drop()
		
		_generate_particles()
		
		if sprite.region_rect.size.x < 1 or sprite.region_rect.size.y < 1 or chop_counter > 3:
			destroy()
		else:
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
			new_region_rect.position.x += new_region_rect.size.x
			sprite.region_rect = new_region_rect
			damage_sprite.region_rect = new_region_rect
			var col_shape = max(0, sprite.region_rect.size.x / 2 - 2)
			hurtbox_collision_shape.shape.extents.x = col_shape
			collision_shape.shape.extents.x = col_shape
			
			var pos_adjust = (sprite.region_rect.size.x * 0.5)
			_adjust_positions(pos_adjust, 0)
			
		else:
			var new_region_rect = sprite.region_rect
			
			new_region_rect.size.y /= 2
			new_region_rect.position.y += new_region_rect.size.y
			sprite.region_rect = new_region_rect
			var damage_new_region_rect = new_region_rect
			damage_sprite.position.y = sprite.position.y - damage_sprite_margin
			damage_sprite.region_rect = damage_new_region_rect
			
			var col_shape = max(0, sprite.region_rect.size.y / 2 - 2)
			hurtbox_collision_shape.shape.extents.y = col_shape
			collision_shape.shape.extents.y = col_shape
			
			if pop_up:
				linear_velocity = pop_up_velocity
				await get_tree().create_timer(pop_up_duration).timeout
				linear_velocity = Vector2.ZERO
			else:
				var pos_adjust = (sprite.region_rect.size.y * 0.5)
				_adjust_positions(0, pos_adjust)


func _adjust_positions(x_change, y_change) -> void:
	sprite.position.y += y_change
	damage_sprite.position.y += y_change
	collision_shape.position.y += y_change
	hurtbox_collision_shape.position.y += y_change
	
	sprite.position.x += x_change
	damage_sprite.position.x += x_change
	collision_shape.position.x += x_change
	hurtbox_collision_shape.position.x += x_change


func destroy():
	if not Engine.is_editor_hint():
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


func _generate_particles():
	if take_damage_sound:
		SoundPlayer.play_sound_positional(take_damage_sound, global_position)
	else:
		SoundPlayer.play_sound_positional("dirt", global_position)

	var explode = particle_scene.instantiate()
	explode.restart()
	explode.texture = particle_texture
	var width : int = particle_texture.get_width() / particle_texture_width
	explode.material.set_particles_anim_h_frames(width)
	explode.position = collision_shape.global_position
	explode.position.y -=  collision_shape.shape.size.y * 0.5
	explode.z_index = SortLayer.PLAYER
	get_parent().add_child(explode)


	var shape = collision_shape.shape
	if shape is RectangleShape2D:
		var area = shape.extents.x * 2 * shape.extents.y * 2
		var num_particles = int(area / (32 * 32) * 32)
		explode.amount = num_particles
	explode.process_material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	var new_width = collision_shape.shape.size.x * 0.5
	var new_height = collision_shape.shape.size.y * 0.5
	explode.process_material.emission_box_extents = Vector3(new_width, new_height, 0)
