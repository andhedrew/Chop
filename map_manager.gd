@tool
extends CanvasLayer

var number_of_levels := 4.0
var pos := 0.0
var target_position := 0.0
var new_scene : String
var move_pin := false
var moving_paper := false
var paper_pos := 0.0
var drop_pin := false
var starting_path_pos := Vector2.ZERO

@export_range(1, 8) var world_number: int = 1
@export_group("Map Testing")
@export var debug_test := false
@export var debug_setup := [2.0, "res://levels_and_level_objects/level_scenes/world_1_levels/1-2.tscn"]

@onready var paper := $Control/paper
@onready var roll := $Control/roll
@onready var path_follow := $Control/Path2D/PathFollow2D
@onready var path := $Control/Path2D
@onready var animation_player := $AnimationPlayer


func _ready():
	if not Engine.is_editor_hint():
		roll.visible = true
		starting_path_pos = path.position
		paper_pos = - ((paper.texture.get_width()/8) * world_number)
		paper.position.x = paper_pos
		roll.position = Vector2(-5080, -320)
		if debug_test:
			_setup(debug_setup[0], debug_setup[1])

		GameEvents.map_started.connect(_setup) #pass position, next scene
		await get_tree().create_timer(2.0).timeout
		animation_player.play("roll")



func _process(_delta):
	if not Engine.is_editor_hint():
		if moving_paper:
			var move_speed := 0.02
			paper.position.x = lerp(paper.position.x, paper_pos, move_speed)
			roll.position.x = lerp(roll.position.x, roll.position.x+640, move_speed)
			if paper.position.x-5 <= paper_pos:
				drop_pin = true
		if drop_pin:
			var tween = create_tween()
			tween.tween_property(path, "position", starting_path_pos, 0.2).set_trans(Tween.TRANS_LINEAR)
			await get_tree().create_timer(1.0).timeout
			_end_scene()
		if move_pin:
			path_follow.progress_ratio = lerp(path_follow.progress_ratio, pos, 0.01)
			if path_follow.progress_ratio+0.05 >= pos:
				await get_tree().create_timer(1.0).timeout
				_end_scene()
				move_pin = false
	else:
		paper_pos = - ((paper.texture.get_width()/8) * world_number)
		paper.position.x = paper_pos


func _setup(new_position: float, next_scene: String) -> void:
	if new_position == 5.0:
		path.position.y = -400
		path_follow.progress_ratio = 0.0
		pos = 0.0
		paper_pos -= paper.texture.get_width()/8
		await animation_player.animation_finished
		moving_paper = true
		move_pin = false
	else:
		var start_pos = new_position
		var end_pos = new_position+1.0/number_of_levels
		var start_pos_adj = start_pos/number_of_levels
		
		path_follow.progress_ratio = start_pos_adj
		pos = end_pos
		if pos > 1:
			pos = 1
		await get_tree().create_timer(4.0).timeout
		move_pin = true
	
	new_scene = next_scene
	
	



func _end_scene() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(new_scene)
	Fade.crossfade_execute() 

