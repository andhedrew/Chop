extends RigidBody2D



func _ready():
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _on_hurtbox_area_entered(area) -> void:
	queue_free()
