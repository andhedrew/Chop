extends CanvasLayer


func _ready():
	$AnimationPlayer.play("fade_in")

func _process(_delta):
	if $VBoxContainer/HBoxContainer/Button.button_pressed:
		_on_button_pressed()


func _on_button_pressed() -> void:
	GameEvents.transition_to_map.emit()

