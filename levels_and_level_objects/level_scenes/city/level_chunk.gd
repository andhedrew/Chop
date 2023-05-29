extends Node

@export var scenes: Array[PackedScene] = []

var current_scene = null

func _ready():
	if get_child_count() > 0:
		current_scene = get_child(0)

func _process(_delta):
	if Input.is_action_pressed("1"):
		change_scene(0)
	elif Input.is_action_pressed("2"):
		change_scene(1)
	elif Input.is_action_pressed("3"):
		change_scene(2)
	elif Input.is_action_pressed("4"):
		change_scene(3)
	elif Input.is_action_pressed("5"):
		change_scene(4)

func change_scene(index):
	if index < 0 or index >= scenes.size():
		return
	var old_position = Vector2.ZERO
	if current_scene != null:
		old_position = current_scene.position
		remove_child(current_scene)
	current_scene = scenes[index].instantiate()
	current_scene.position = old_position
	add_child(current_scene)
