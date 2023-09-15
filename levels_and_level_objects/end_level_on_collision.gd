extends Area2D
func _ready():
	self.body_entered.connect(_on_body_entered)
	GameEvents.boss_defeated.connect(_on_boss_defeated)


func _on_body_entered(body) -> void:
	if body is Player:
		GameEvents.cutscene_started.emit()
		if !owner.skip_map_after_this_level:
			GameEvents.continue_day.emit()
			await get_tree().create_timer(3).timeout
			GameEvents.transition_to_map.emit()


func _on_boss_defeated() -> void:
	monitoring = true
