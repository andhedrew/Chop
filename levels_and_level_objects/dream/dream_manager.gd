extends CanvasLayer

@onready var label := $Label
var can_skip := false
var current_slide := 0
var dream_slides: Array[Texture]
var can_change_slide := true

func _ready():
	await get_tree().create_timer(2.0).timeout
	can_skip = true
	await get_tree().create_timer(15.0).timeout
	$AnimationPlayer.play("text_fade_in")

func _process(_delta):
	if can_skip:
		if Input.is_anything_pressed():
			if can_change_slide:
				current_slide += 1
				if current_slide < dream_slides.size():
					$Dream/Sprite2D.texture = dream_slides[current_slide]
					can_change_slide = false
					await get_tree().create_timer(0.5).timeout
					_on_Timer_timeout()
				else:
					$AnimationPlayer.play("fade_out")

func _on_Timer_timeout():
	can_change_slide = true

func _destroy(): # handled by animation player
	GameEvents.morning_started.emit()
	queue_free()
