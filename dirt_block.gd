extends CharacterBody2D

func _ready():
	$Hurtbox.area_entered.connect(_on_area_entered)
	$Hitbox.monitorable = false

func _physics_process(delta):

	move_and_slide()
	if !is_on_floor():
		velocity.y += Param.GRAVITY * delta
		$Hitbox.monitorable = true
		velocity.y += Param.GRAVITY * delta
	else: 
		$Hitbox.monitorable = false

func _on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if !hitbox.fire and !hitbox.syphon:
			var dirt := preload("res://vfx/dirt_explode.tscn").instantiate()
			dirt.restart()
			dirt.position = global_position
			get_node("/root/").add_child(dirt)
			queue_free()
	hitbox.owner._destroy()
