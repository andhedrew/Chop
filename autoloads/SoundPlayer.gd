extends Node


@onready var audio_players := $AudioPlayers
@onready var positional_audio_players := $PositionalAudioPlayers

func _ready():
	pass
	#play_music("8bitmusic")

func play_sound(sound: Variant):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
		if sound is String:
			audio_stream_player.stream = load("res://audio/sounds/"+ sound +".wav")
		elif sound is AudioStreamWAV:
			audio_stream_player.stream = sound
		audio_stream_player.play()

func play_music(sound: String):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
			audio_stream_player.stream = load("res://audio/Music/"+ sound +".ogg")
			audio_stream_player.play()


func play_sound_positional( sound: Variant, new_global_position: Vector2, distance: float = 250.0 ):
	var audio_stream_player = AudioStreamPlayer2D.new()
	positional_audio_players.add_child(audio_stream_player)
	audio_stream_player.global_position = new_global_position
	audio_stream_player.max_distance = distance
	audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
	if sound is String:
		audio_stream_player.stream = load("res://audio/sounds/"+ sound +".wav")
	elif sound is AudioStreamWAV:
		audio_stream_player.stream = sound
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.queue_free()
	
