extends CharacterBody2D
#
#func _ready():
#	z_index = SortLayer.FOREGROUND
#	$Hurtbox.area_entered.connect(_on_hitbox_entered)
#
#func _process(_delta):
#	if health <= 0:
#		die()
#
#
#
#func _on_hitbox_entered(hitbox) -> void:
#	if hitbox is HitBox:
#		health -= 1
#		SoundPlayer.play_sound("impact_celery")
#		$Pivot/EffectsPlayer.play("effects/take_damage")
#		$Pivot/AnimationPlayer.play("hurt")
#		await $Pivot/AnimationPlayer.animation_finished
#		$Pivot/AnimationPlayer.play("sad")
#
#
#func die() -> void:
#	call_deferred("queue_free")
#	OS.delay_msec(130)
#	var explode := preload("res://vfx/explosion.tscn").instantiate()
#	explode.position = global_position
#	explode.big = true
#	get_node("/root/").add_child(explode)
#	if death_pieces:
#		var spacing = 2
#		var starting_x = (death_pieces.size()*(spacing*.5))
#		for sprite in death_pieces:
#			var pickup := preload("res://pickups/food_pickup.tscn").instantiate()
#			pickup.setup(sprite)
#			pickup.position = global_position
#			pickup.velocity = Vector2(starting_x, randf_range(-4, -6))
#			starting_x -= spacing
#			get_node("/root/World").add_child(pickup)
