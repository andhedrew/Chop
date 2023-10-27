extends Area2D

func _ready():
	self.body_entered.connect(on_body_entered)


func on_body_entered(body) -> void:
	if body is Player:
		body.take_damage(100)
	if body is Enemy:
		body.queue_free()
