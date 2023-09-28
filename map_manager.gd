extends CanvasLayer


@onready var animation_player := $AnimationPlayer
@export_range(1, 8) var world_number: int = 1
var number_of_levels := 4.0
var pos := 0.0
var target_position := 0.0
var new_scene : String
var move_pin := false
var moving_paper := false
var paper_pos := 0.0

@onready var paper := $Control/paper
@onready var roll := $Control/roll
@onready var path_follow := $Control/Path2D/PathFollow2D


func _ready():
	paper_pos = - ((paper.texture.get_width()/8) * world_number)
	paper.position.x = paper_pos
	roll.position = Vector2(-5080, -320)
	_setup(1.0, "res://levels_and_level_objects/level_scenes/world_1_levels/1-2.tscn")

	GameEvents.map_started.connect(_setup) #pass position, next scene
	await get_tree().create_timer(2.0).timeout
	animation_player.play("roll")


func _process(_delta):
	if moving_paper:
		var move_speed := 0.02
		paper.position.x = lerp(paper.position.x, paper_pos, move_speed)
		roll.position.x = lerp(roll.position.x, roll.position.x+640, move_speed)
		if paper.position.x == paper_pos:
			move_pin = true
	if move_pin:
		path_follow.progress_ratio = lerp(path_follow.progress_ratio, pos, 0.05)
		if path_follow.progress_ratio+0.01 >= pos:
			await get_tree().create_timer(2.0).timeout
			_end_scene()
			move_pin = false
			


func _setup(new_position: float, next_scene: String) -> void:
	if new_position == 1.0:
		paper_pos -= paper.texture.get_width()/8
		await animation_player.animation_finished

		moving_paper = true
		move_pin = false
	else:
		move_pin = true

	var start_pos = new_position - 1.0
	var end_pos = new_position/number_of_levels
	var start_pos_adj = start_pos/number_of_levels
	new_scene = next_scene

	path_follow.progress_ratio = start_pos_adj
	pos = end_pos
	if pos > 1:
		pos = 1
	await get_tree().create_timer(4.0).timeout
	


func _end_scene() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(new_scene)
	Fade.crossfade_execute() 

