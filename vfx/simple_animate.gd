extends Node2D

@onready var animation_player = get_node("AnimationPlayer")

func _ready():
	z_index = SortLayer.IN_FRONT
	animation_player.play("animate")
	await animation_player.animation_finished
	queue_free()
