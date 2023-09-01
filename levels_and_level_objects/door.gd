extends Area2D


var cutscene_running := false

func _ready():
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if !cutscene_running:
		if body is Player:
			owner.transition_to_level("res://playground.tscn")
		

func _on_cutscene_start():
	print_debug("running")
	cutscene_running = true

func _on_cutscene_end():
	print_debug("not")
	cutscene_running = false
