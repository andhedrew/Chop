extends Area2D


func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body is Player:
		body.has_booster_upgrade = true
		get_parent().queue_free()
