extends Area2D

func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if body is Player:
		SoundPlayer.play_sound("bump")
		var direction = (body.global_position - global_position).normalized()
		direction.y = -1
		body.velocity = direction * 160

