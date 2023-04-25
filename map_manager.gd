extends Node2D


@onready var animation_player := $AnimationPlayer
var number_of_levels := 20.0
var test := false
var pos := 0.0
var target_position := 0.0
var new_scene : String
var move_pin := false
func _ready():
	GameEvents.cutscene_started.emit()
	animation_player.play("roll")
	GameEvents.map_started.connect(_setup)


func _process(delta):
	if !test:
		GameEvents.map_started.emit(15.0, "res://levels_and_level_objects/level_scenes/city_level_2.tscn")
		test = true
	
	if move_pin:
		$Control/Path2D/PathFollow2D.progress_ratio = lerp($Control/Path2D/PathFollow2D.progress_ratio, pos, 0.05)
		if $Control/Path2D/PathFollow2D.progress_ratio+0.01 >= pos:
			_end_scene()
			move_pin = false


func _setup(new_position: float, next_scene: String) -> void:
	target_position = new_position
	new_scene = next_scene
	pos = target_position/number_of_levels
	await get_tree().create_timer(1.0).timeout
	move_pin = true


func _end_scene() -> void:
	await get_tree().create_timer(0.5).timeout
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	get_tree().change_scene_to_file(new_scene)
	await Fade.crossfade_execute() 
	GameEvents.cutscene_ended.emit()
