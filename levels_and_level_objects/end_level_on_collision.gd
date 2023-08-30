extends Area2D
func _ready():
	self.body_entered.connect(_on_body_entered)


func _on_body_entered(body) -> void:
	if body is Player:
		GameEvents.cutscene_started.emit()
		GameEvents.continue_day.emit()
