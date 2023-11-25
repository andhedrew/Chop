extends Node2D

var bullet = preload("res://bullets/stalactite_bullet/stalactite_bullet.tscn")
@export var hazard := false
var fired_bullet := false
var ray_cast = RayCast2D.new()
var raycast_set_up := false

func _ready():
	if hazard:
		$SpriteHazard.visible = true
		$Sprite2D.visible = false
		create_ray_cast()
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func create_ray_cast():
	add_child(ray_cast)  # Add it as a child of the current node
	print_debug("ray_cast created: " + str(ray_cast))
	# Set collision masks
	ray_cast.set_collision_mask_value(2, true)
	ray_cast.set_collision_mask_value(1, true)
	ray_cast.set_collision_mask_value(7, true)
	ray_cast.set_collision_mask_value(8, true)
	ray_cast.set_collision_mask_value(9, true)
	ray_cast.set_collision_mask_value(10, true)

	ray_cast.enabled = true  # Enable the raycast
	ray_cast.target_position.y = 1  # Start with a minimal length

	# Extend the raycast until it collides or reaches 500 pixels
	while not ray_cast.is_colliding():
		await get_tree().create_timer(0.01).timeout
		ray_cast.target_position.y += 16
		if ray_cast.target_position.y >= 250:
			break
	# If a collision occurred, reduce the length by 1 pixel
	while ray_cast.is_colliding():
		await get_tree().create_timer(0.01).timeout
		ray_cast.target_position.y -= 4
	ray_cast.set_collision_mask_value(7, false)
	raycast_set_up = true

func _process(delta):
	if Engine.is_editor_hint():
		if hazard:
			$SpriteHazard.visible = true
			$Sprite2D.visible = false
		else:
			$SpriteHazard.visible = false
			$Sprite2D.visible = true
	else:
		if ray_cast.is_colliding() and raycast_set_up:
			if not fired_bullet:
				_fire_bullet()
				fired_bullet = true


func _on_hurtbox_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", global_position)
			_fire_bullet()


func _fire_bullet():
	$Hurtbox.set_deferred("monitoring", false)
	$Sprite2D.frame = 1
	$SpriteHazard.frame = 1
	var bullet_inst = bullet.instantiate()
	owner.call_deferred("add_child", bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 250
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.position = $Hurtbox.global_position
	bullet_inst.hazard = hazard

