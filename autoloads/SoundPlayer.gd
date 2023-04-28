extends Node


@onready var audio_players := $AudioPlayers
@onready var ambient_players := $AmbientSoundPlayers
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


func play_ambient(sound: Variant) -> AudioStreamPlayer:
	var old_player = null
	var old_player_tween = null
	if ambient_players.get_child_count() > 0:
		old_player = ambient_players.get_child(0)
		old_player_tween = get_tree().create_tween()
		old_player_tween.tween_property(old_player, "volume_db", -80, 5.0)
		old_player_tween.play()
	var audio_stream_player = preload("res://audio/audio.tscn").instantiate()
	ambient_players.add_child(audio_stream_player)
	if sound is String:
		audio_stream_player.stream = load("res://audio/ambient/"+ sound +".wav")
	elif sound is AudioStreamWAV:
		audio_stream_player.stream = sound
	# Fade in the sound
	var tween = get_tree().create_tween()
	audio_stream_player.set_volume_db(-80)
	audio_stream_player.play()
	tween.tween_property(audio_stream_player, "volume_db", -30, 5.0)
	tween.play()
	if old_player:
		await old_player_tween.finished
		old_player.queue_free()
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
	
