extends Node2D

@onready var animation_player = get_node("AnimationPlayer")
@export var sound: String = "slash_cut"

func _ready():
	SoundPlayer.play_sound(sound)
	
	var angle_amount := 180
	var random_angle = randf_range(-angle_amount, angle_amount)
	rotation_degrees += random_angle
	z_index = SortLayer.IN_FRONT
	animation_player.play("animate")
	await animation_player.animation_finished
	queue_free()
