extends ColorRect

var squish_factor : float = 0.0
var maximum_squish_factor : float = 0.2

var cutscene_running := false

var speed := 0.01

func _ready():
	
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	self.material.set_shader_parameter("squishedness", 0.0)

func _process(_delta):
	if cutscene_running:
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
