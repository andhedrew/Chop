extends ColorRect

var squish_factor : float = 0.0
var maximum_squish_factor : float = 0.2

var cutscene_running := false
var dialogue_running := false
var speed := 0.01

func _ready():
	
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	GameEvents.dialogue_started.connect(_on_dialogue_start)
	GameEvents.dialogue_finished.connect(_on_dialogue_fin)
	self.material.set_shader_parameter("squishedness", 0.0)

func _process(_delta):
	if cutscene_running and not dialogue_running:
		if squish_factor < maximum_squish_factor:
			squish_factor += speed
	else:
		if squish_factor > 0:
			squish_factor -= speed
	self.material.set_shader_parameter("squishedness", squish_factor)

func _on_cutscene_start() -> void:
	cutscene_running = true

func _on_cutscene_end() -> void:
	cutscene_running = false


func _on_dialogue_start() -> void:
	dialogue_running = true

func _on_dialogue_fin() -> void:
	dialogue_running = false
