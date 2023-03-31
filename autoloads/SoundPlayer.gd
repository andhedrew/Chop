extends Node


@onready var audio_players := $AudioPlayers
@onready var music_players := $MusicPlayers
@onready var positional_audio_players := $PositionalAudioPlayers

func _ready():
	pass

func play_sound(sound: Variant) -> AudioStreamPlayer:
	var audio_stream_player = preload("res://audio/audio.tscn").instantiate()
	audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
	audio_players.add_child(audio_stream_player)
	if sound is String:
		audio_stream_player.stream = load("res://audio/sounds/"+ sound +".wav")
	elif sound is AudioStreamWAV:
		audio_stream_player.stream = sound
	audio_stream_player.play()
	return audio_stream_player
	
	


func play_music(sound: String) -> AudioStreamPlayer:
	for audio_stream_player in music_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.stream = load("res://audio/music/"+ sound +".ogg")
			audio_stream_player.play()
			return audio_stream_player
	return null


func play_sound_positional( 
		sound: Variant, 
		new_global_position: Vector2, 
		distance: float = 250.0 
		) -> AudioStreamPlayer2D:
	var audio_stream_player = preload("res://audio/audio_positional.tscn").instantiate()
	positional_audio_players.add_child(audio_stream_player)
	audio_stream_player.global_position = new_global_position
	audio_stream_player.max_distance = distance
	audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
	if sound is String:
		audio_stream_player.stream = load("res://audio/sounds/"+ sound +".wav")
	elif sound is AudioStreamWAV:
		audio_stream_player.stream = sound
	audio_stream_player.play()
	return audio_stream_player
	
