extends Node2D

var bullet = preload("res://bullets/stalactite_bullet/stalactite_big_bullet.tscn")
var bullet_no_tip = preload("res://bullets/stalactite_bullet/stalactite_big_bullet_chopped.tscn")
var tip_bullet = preload("res://bullets/stalactite_bullet/stalactite_bullet.tscn")
@export var hazard := false
var fired_bullet := false

var fired_tip:= false
var raycast_set_up := false
var ray_cast = RayCast2D.new()  # Create a new RayCast2D instance

func _ready():
	if hazard:
		$SpriteHazard.visible = true
		$Sprite2D.visible = false
		create_ray_cast()
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	$Hurtbox2.area_entered.connect(_on_hurtbox2_area_entered)
	if hazard:
		$Hurtbox.set_deferred("monitoring", false)
		$Hurtbox2.set_deferred("monitoring", false)

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
			if not fired_bullet and not fired_tip:
				$Shield.monitoring = false
				_fire_bullet()
				

func _on_hurtbox_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", global_position)
			_fire_bullet()


func _on_hurtbox2_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			fired_tip = true
		
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", $Hurtbox2.global_position)
			_fire_tip_bullet()

func _fire_bullet():
	fired_bullet = true
	$Hurtbox.set_deferred("monitoring", false)
	$Hurtbox2.set_deferred("monitoring", false)
	$Sprite2D.frame = 1
	$SpriteHazard.frame = 1
	var bullet_inst
	if fired_tip:
		bullet_inst = bullet_no_tip.instantiate()
	else:
		bullet_inst = bullet.instantiate()
	owner.add_child(bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 200
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.hazard = hazard
	


func _fire_tip_bullet():
	$Hurtbox2.set_deferred("monitoring", false)
	$Sprite2D.frame = 2
	$SpriteHazard.frame = 2
	var bullet_inst = tip_bullet.instantiate()
	owner.add_child(bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 250
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.position = $Hurtbox2.global_position
	bullet_inst.hazard = hazard
	
