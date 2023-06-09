extends GPUParticles2D

var target_position : Vector2 = Vector2.ZERO
var original_settings = {}


func _ready():
	GameEvents.player_started_syphoning.connect(_player_syphoning)
	GameEvents.player_done_syphoning.connect(_player_not_in_syphon_state)
	original_settings["direction_x"] = process_material.direction.x
	original_settings["direction_y"] = process_material.direction.y
	original_settings["amount"] = amount
	original_settings["velocity_min"] = process_material.initial_velocity_min
	original_settings["velocity_max"] = process_material.initial_velocity_max
	original_settings["gravity_y"] = process_material.gravity.y
	original_settings["spread"] = process_material.spread
	original_settings["lifetime"] = lifetime



func _process(_delta):
	if target_position != Vector2.ZERO:
		process_material.direction.x = -target_position.x
		process_material.direction.y = -target_position.y
		amount = 3
		process_material.initial_velocity_min = 160
		process_material.initial_velocity_max = 180
		process_material.gravity.y = 0
		process_material.spread = 30
		lifetime = 1



func _player_not_in_syphon_state(_succussful_syphon : bool) -> void:
	target_position = Vector2.ZERO
	process_material.direction.x = original_settings["direction_x"]
	process_material.direction.y = original_settings["direction_y"]
	amount = original_settings["amount"]
	process_material.initial_velocity_min = original_settings["velocity_min"]
	process_material.initial_velocity_max = original_settings["velocity_max"]
	process_material.gravity.y = original_settings["gravity_y"]
	process_material.spread = original_settings["spread"]
	lifetime = original_settings["lifetime"]



func _player_syphoning(player_pos: Vector2) -> void:
	target_position = owner.global_position - player_pos

