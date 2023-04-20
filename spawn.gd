extends Node2D


func _ready():
	z_index = SortLayer.PLAYER
	var spawn_object := get_child(0)
	spawn_object.global_position = position


func respawn(object):
	remove_child(object)
	object.reset_and_upgrade()
	object.velocity = Vector2.ZERO
	await get_tree().create_timer(1.0).timeout
	add_child(object)
	object.global_position = position
