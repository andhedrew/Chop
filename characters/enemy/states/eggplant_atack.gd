class_name EggplantAttack
extends State


@onready var player_detector := $"../../Pivot/player_detector"


# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("attack")
	owner.animation_player.speed_scale = randf_range(0.55, 0.65)
	player_detector.body_exited.connect(_on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
	
func _on_body_exited(body) -> void:
		state_machine.transition_to("Idle")

