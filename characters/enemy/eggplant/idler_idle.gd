class_name IdlerIdle
extends State

@onready var ledge_left := $"../../adjacent_ledge_check_left"
@onready var ledge_right := $"../../adjacent_ledge_check_right"
@onready var wall_left := $"../../wall_check_left"
@onready var wall_right := $"../../wall_check_right"
@onready var player_detector := $"../../Pivot/player_detector"
var transitioned := false
var timer: Timer
func _ready():
	player_detector.body_entered.connect(_on_player_detected)
	

func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")
	owner.animation_player.speed_scale = randf_range(0.55, 0.65)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	if !owner.is_on_floor():
		state_machine.transition_to("Fall")


func _on_player_detected(body) -> void:
	state_machine.transition_to("Attack")
