extends CharacterBody2D

var sound_timer := 10
var sound_tim := 0

func _process(_delta) -> void:
	sound_tim += 1
	if sound_tim > sound_timer:
		SoundPlayer.play_sound_positional("hiss_1", 300.0, global_position)
		sound_tim = 0
	
