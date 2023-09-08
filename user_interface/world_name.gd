extends CanvasLayer

@onready var name_1 := $Control/Label
@onready var name_2 := $Control/Label2

func _ready():
	
	if owner.checkpoint:
		var checkpoint_level = get_tree().current_scene.scene_file_path
		var current_name = LevelInfo.WORLD_NAME[checkpoint_level]
		name_1.text = current_name
		name_2.text = current_name

func _process(delta):
	if $Control.position.x < 0:
		$Control.position.x = lerpf($Control.position.x, 0, 0.2)
	elif $Control.position.x >= 0:
		print_debug("1esgrserg")
		$Control.position.y = lerpf($Control.position.y, 500.0, 0.2)
