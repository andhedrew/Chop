extends CanvasLayer

@onready var label := $Label
var can_skip := false
func _ready():
	await get_tree().create_timer(2.0).timeout
	can_skip = true
	await get_tree().create_timer(15.0).timeout
	$AnimationPlayer.play("text_fade_in")


func _process(delta):
	if can_skip:
		if Input.is_anything_pressed():
			$AnimationPlayer.play("fade_out")


func _destroy():
	GameEvents.morning_started.emit()
	queue_free()
