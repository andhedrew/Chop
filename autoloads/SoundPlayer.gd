extends Node


@onready var audio_players := $AudioPlayers
@onready var positional_audio_players := $PositionalAudioPlayers

func _ready():
	pass
	#play_music("8bitmusic")

func play_sound(sound: String):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
			audio_stream_player.stream = load("res://sounds/"+ sound +".wav")
			audio_stream_player.play()
			break

func play_music(sound: String):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
			audio_stream_player.stream = load("res://sounds/Music/"+ sound +".ogg")
			audio_stream_player.play()
			break


func play_sound_positional(sound: String, distance: float, new_position: Vector2):
	var audio_stream_player = AudioStreamPlayer2D.new()
	positional_audio_players.add_child(audio_stream_player)
	audio_stream_player.global_position = new_position
	audio_stream_player.max_distance = distance
	audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
	audio_stream_player.stream = load("res://sounds/"+ sound +".wav")
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.queue_free()
	
