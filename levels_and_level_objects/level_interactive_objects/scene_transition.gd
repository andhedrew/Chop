extends Area2D

@export_file("*.tscn") var new_scene

func _ready():
	self.body_entered.connect(on_body_entered)


func on_body_entered(body) -> void:
	if body is Player:
		await Fade.fade_out().finished
		get_tree().change_scene_to_file(new_scene)
		Fade.fade_in()
