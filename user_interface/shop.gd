extends CanvasLayer


func _process(delta):
	if $VBoxContainer/HBoxContainer/Button.button_pressed:
		_on_button_pressed()


func _on_button_pressed() -> void:
	GameEvents.transition_to_map.emit()
	


	
