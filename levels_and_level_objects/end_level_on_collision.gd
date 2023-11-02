extends Area2D
func _ready():
	self.body_entered.connect(_on_body_entered)
	GameEvents.boss_defeated.connect(_on_boss_defeated)


func _on_body_entered(body) -> void:
	if body is Player:
		GameEvents.camera_change_focus.emit(get_parent())
		GameEvents.cutscene_started.emit()
		
		GameEvents.continue_day.emit()
		if !get_node("/root/World").skip_map_after_this_level:
			await get_tree().create_timer(3).timeout
			GameEvents.transition_to_map.emit()
		else:
			get_node("/root/World").transition_to_next_level()


func _on_boss_defeated() -> void:
	monitoring = true
