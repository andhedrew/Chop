extends Node2D

var flag_y_pos: float
var animate_flag := false
var flag_in_place = false



func _ready():
	z_index = SortLayer.FOREGROUND
	flag_y_pos = $ExplodingProp.position.y
	
	var start_at_checkpoint = SaveManager.load_item("checkpoint_reached_this_level")
	if start_at_checkpoint:
		$ExplodingProp.queue_free()
		$SuccessFlag.position.y = flag_y_pos

func _process(_delta):
	if not has_node("ExplodingProp") and not flag_in_place and not animate_flag:
		SaveManager.save_item("checkpoint_reached_this_level", true)
		SaveManager.save_item("checkpoint_position", global_position)
		await get_tree().create_timer(1.0).timeout
		animate_flag = true

	
	if animate_flag:
		$SuccessFlag.position.y = move_toward($SuccessFlag.position.y, flag_y_pos, 0.5)
		if $SuccessFlag.position.y-1 <= flag_y_pos:
			flag_in_place = true
			animate_flag = false
