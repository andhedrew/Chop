extends Area2D


var cutscene_running := false

var cheated := false
func _ready():
	self.body_entered.connect(_on_body_entered)
	GameEvents.boss_defeated.connect(_on_boss_defeated)
	GameEvents.cheatmode.connect(_cheat_skip_level)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)


func _on_body_entered(body) -> void:
	if not cutscene_running:
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


func _cheat_skip_level():
	# Skips levels when in debug: Reenable when testing the flow of the whole game quickly
	if not cheated:
#		GameEvents.cutscene_started.emit()
#
#		GameEvents.continue_day.emit()
#		if !get_node("/root/World").skip_map_after_this_level:
#			await get_tree().create_timer(3).timeout
#			GameEvents.transition_to_map.emit()
#		else:
#			get_node("/root/World").transition_to_next_level()
		cheated = true



func _on_cutscene_start():
	print_debug("running")
	cutscene_running = true

func _on_cutscene_end():
	print_debug("not")
	cutscene_running = false
