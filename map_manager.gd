extends CanvasLayer


@onready var animation_player := $AnimationPlayer
var number_of_levels := 20.0
var pos := 0.0
var target_position := 0.0
var new_scene : String
var move_pin := false


func _ready():
	GameEvents.map_started.connect(_setup) #pass position and next scene
	await get_tree().create_timer(2.0).timeout
	animation_player.play("roll")


func _process(delta):
	if move_pin:
		$Control/Path2D/PathFollow2D.progress_ratio = lerp($Control/Path2D/PathFollow2D.progress_ratio, pos, 0.05)
		if $Control/Path2D/PathFollow2D.progress_ratio+0.01 >= pos:
			await get_tree().create_timer(2.0).timeout
			_end_scene()
			move_pin = false
			


func _setup(new_position: float, next_scene: String) -> void:
	var start_pos = new_position - 1.0
	var end_pos = new_position/number_of_levels
	var start_pos_adj = start_pos/number_of_levels
	new_scene = next_scene
	$Control/Path2D/PathFollow2D.progress_ratio = start_pos_adj
	pos = end_pos
	if pos > 1:
		pos = 1
	await get_tree().create_timer(4.0).timeout
	move_pin = true


func _end_scene() -> void:
	Fade.crossfade_prepare(0.4, "ChopHorizontal")
	SoundPlayer.play_sound("paper_rip")
	get_tree().change_scene_to_file(new_scene)
	Fade.crossfade_execute() 

