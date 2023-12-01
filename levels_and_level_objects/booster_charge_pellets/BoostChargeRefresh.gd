extends Node2D


var active := true

func _ready():
	z_index = SortLayer.FOREGROUND
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	$Timer.timeout.connect(_on_timer_timeout)


func _on_hurtbox_area_entered(area) -> void:
	if area is HitBox:
		if area.execute and active:
			GameEvents.add_a_charge.emit()
			$AnimatedSprite2D.animation = "die"
			await $AnimatedSprite2D.animation_finished
			$AnimatedSprite2D.animation = "dead"
			active = false
			$Timer.start()


func _on_timer_timeout() -> void:
	
	active = true
	GameEvents.new_vfx.emit("res://vfx/smoke_puff_up.tscn", global_position)
	$AnimatedSprite2D.animation = "reignite"
	$AnimatedSprite2D.play()
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.animation = "default"
	$AnimatedSprite2D.play()
