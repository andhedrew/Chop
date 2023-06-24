extends Node2D

@onready var animation_player = get_node("AnimationPlayer")
var big = false
func _ready():
	z_index = SortLayer.IN_FRONT
	animation_player.play("explode")
	SoundPlayer.play_sound_positional("explosion", global_position)
	if big:
		$Sprite2D.texture = preload("res://vfx/explosion_x2.png")
		
	SoundPlayer.play_sound_positional("explosion", position)
	await animation_player.animation_finished
	
	queue_free()
