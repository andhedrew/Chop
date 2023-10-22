extends Node2D


func _ready():
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _on_hurtbox_area_entered(area) -> void:
	if area is HitBox:
		if area.execute:
			GameEvents.add_a_charge.emit()
			$AnimatedSprite2D.animation = "die"
			await $AnimatedSprite2D.animation_finished
			queue_free()
