extends Node2D

var bullet = preload("res://bullets/stalactite_bullet/stalactite_bullet.tscn")

func _ready():
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _on_hurtbox_area_entered(area) ->void:
	if area is HitBox:
		$Sprite2D.frame = 1
		var bullet_inst = bullet.instantiate()
		owner.add_child(bullet_inst)
		var transform = global_transform
		var fire_range = 100
		var speed = 200
		var spread = 0
		var rotation := 90


		bullet_inst.setup(transform, fire_range, speed, rotation, spread)
		$Hurtbox.queue_free()
