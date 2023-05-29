extends AnimationPlayer

func _ready():
	GameEvents.evening_started.connect(_on_end_of_day)
	GameEvents.morning_started.connect(_on_start_of_day)


#func _process(_delta):
#	if Input.is_action_just_pressed("1"):
#		play("sunrise")
#	if Input.is_action_just_pressed("2"):
#		play("day")
#	if Input.is_action_just_pressed("3"):
#		play("sunset")
#	if Input.is_action_just_pressed("4"):
#		play("night")


func _on_end_of_day() -> void:
	await get_tree().create_timer(5.0).timeout
	play("sunset")
	SoundPlayer.play_ambient("cricket")
	await animation_finished
	play("night")



func _on_start_of_day() -> void:
	await get_tree().create_timer(5.0).timeout
	play("sunrise")
	SoundPlayer.play_ambient("bird")
	await animation_finished
	play("day")
