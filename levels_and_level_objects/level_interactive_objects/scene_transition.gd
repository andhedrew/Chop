extends Area2D

@export_file("*.tscn") var new_scene

func _ready():
	self.body_entered.connect(on_body_entered)


func on_body_entered(body) -> void:
	if body is Player:

		Fade.crossfade_prepare(0.4, "ChopHorizontal")
		SoundPlayer.play_sound("paper_rip")
		get_tree().change_scene_to_file(new_scene)
		await Fade.crossfade_execute() 
