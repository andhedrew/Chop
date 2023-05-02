extends CharacterBody2D

func _ready():
	$Hurtbox.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	velocity.y += Param.GRAVITY*.02
	var colliding = move_and_collide(velocity*delta)
	if !colliding:
		if $PlayerEnemyDetector.is_colliding() or $PlayerEnemyDetector2.is_colliding() or $PlayerEnemyDetector3.is_colliding():
			$CollisionShape2D.queue_free()
			_destroy()
	else:
		velocity.y = 0


func _on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if !hitbox.fire and !hitbox.syphon:
			_destroy()


func _destroy() -> void:
	var dirt := preload("res://vfx/dirt_explode.tscn").instantiate()
	dirt.restart()
	dirt.amount = 5
	SoundPlayer.play_sound("dirt")
	dirt.position = global_position
	get_node("/root/").add_child(dirt)
	queue_free()
