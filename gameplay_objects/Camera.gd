extends Camera2D

@export var target: NodePath = ""
var original_target := target
@export var lerpspeed: float = 0.05
var base_lerpspeed: float = 0.05
@export var trauma: float = 0.0
@export var max_x := 150
@export var max_y := 150
@export var max_r := 25
@export var time_scale := 150.0
@export var decay: float = 0.6


var x_lead_amount := 150.0
var x_lead := x_lead_amount
var x_target_lead := x_lead

var x_cutscene_lead := -30.0
var cutscene_running := false

var lerp_speed_adj = lerpspeed*0.2
var y_lead_amount := -70.0
var y_air_lead_amount := y_lead_amount + 130
var y_peek_amount := -70.0
var y_lead := y_lead_amount
var y_target_lead := y_lead
var airtime_index := 0.0
var airspeed := 0.0

var look_distance := 130.0

var y_moving := false

var noise := FastNoiseLite.new()

var target_node: Node
var dashing := false

var setup_letterbox := false
var letterbox_bar_1
var letterbox_bar_2

var freeze_camera := false
var looking := false 


func _ready():
	noise.noise_type =  FastNoiseLite.TYPE_SIMPLEX
	GameEvents.player_attacked.connect(SCREENSHAKE)
	GameEvents.player_executed.connect(BIG_SCREENSHAKE)
	GameEvents.player_changed_state.connect(_on_player_changed_state)
	GameEvents.player_done_syphoning.connect(_on_player_done_syphoning)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	GameEvents.morning_started.connect(_on_morning_start)
	GameEvents.continue_day.connect(_on_morning_start)
	GameEvents.player_died.connect(_on_player_die)
	
	GameEvents.boss_stomped.connect(BIG_SCREENSHAKE)
	GameEvents.boss_hit_wall.connect(SCREENSHAKE) 
	GameEvents.big_explosion.connect(on_big_explosion)
	GameEvents.big_explosion.connect(BIG_SCREENSHAKE)
	
	GameEvents.camera_change_focus.connect(on_change_focus)
	
	GameEvents.player_falling.connect(_on_player_changed_falling_state)
	
#	$Area2D.body_entered.connect(_on_body_entered)
	
	
	set_camera_limits()
	original_target = target
	await get_tree().create_timer(0.001).timeout
	if target_node != null:
		position.y = target_node.position.y + y_target_lead
		position.x = target_node.position.x + x_target_lead


func _process(_delta):
	if has_node(target):
		target_node = get_node(target)
	
	if !freeze_camera:
		if target_node is Player:
			_following_player_adjustments()
			if Input.get_axis("down", "up") != 0:
				_is_looking_up_or_down()
			else:
				_stopped_looking_up_or_down()
		else:
			_following_default_adjustments()
		
		_adjust_positions_taking_margins_into_account()
		_set_position()
		_handle_trauma_and_offset()


func _set_position() -> void:
		if y_moving or looking or target_node != Player:
			position.y = lerp(position.y, target_node.global_position.y + y_target_lead, lerp_speed_adj)
		position.x = lerp(position.x, target_node.global_position.x + x_target_lead, lerp_speed_adj)


func _handle_trauma_and_offset() -> void:
	set_offset(Vector2( \
		randf_range(-1, 1) * trauma, \
		randf_range(-1, 1) * trauma \
	))
	
	position.x = position.x + randf_range(-max_r, max_r) * trauma
	position.y = position.y + randf_range(-max_r, max_r) * trauma
	trauma = lerp(trauma, 0.0, 0.1)
	

func _following_player_adjustments() -> void:
	_cutscene_running_adjustments()
	
	if !dashing:
		_is_not_dashing()
	else:
		_is_dashing()
	
	if target_node.is_on_floor():# or target_node.in_water:
		y_lead = y_lead_amount
		lerpspeed = base_lerpspeed
	else:
		y_lead = y_air_lead_amount
		lerpspeed = base_lerpspeed * 1.5
		


func _following_default_adjustments() -> void:
	x_lead = 0.0
	y_lead = 0.0
	x_target_lead = lerp(x_target_lead, x_lead, lerpspeed)
	y_target_lead = lerp(y_target_lead, y_lead, lerpspeed)



func _adjust_positions_taking_margins_into_account() -> void:
		var margin_inside = 60 # define the margin
		var margin_outside = 80 # define the margin
		var margin_limit = 100
		var _screen_size = get_viewport_rect().size # get the size of the viewport
		
		if abs(target_node.position.y - position.y) > margin_outside:
			y_moving = true
		elif abs(target_node.position.y - position.y) < margin_inside:
			y_moving = false
		
		lerp_speed_adj = lerpspeed*0.2
		
		if abs(target_node.position.y - position.y) > margin_limit:
			lerp_speed_adj = lerpspeed


func _is_looking_up_or_down() -> void:
	looking = true
	
	var look_direction = \
	Vector2(Input.get_axis("right", "left"), 
	Input.get_axis("down", "up")).normalized()
	
	if look_direction.y > 0:
		y_target_lead = -look_distance
	elif look_direction.y < 0:
		y_target_lead = look_distance

func _stopped_looking_up_or_down() -> void:
	looking = false
	y_target_lead = y_lead


func _is_dashing() -> void:
	var look_direction = \
	Vector2(Input.get_axis("right", "left"), 
	Input.get_axis("down", "up")).normalized()

	if look_direction.x > 0:
		x_lead = -x_lead_amount
	elif look_direction.x < 0:
		x_lead = x_lead_amount
	y_lead = 0


func _is_not_dashing() -> void:
	var look_direction = \
	Vector2(Input.get_axis("right", "left"), 
	Input.get_axis("down", "up")).normalized()

	if look_direction.x > 0:
		x_lead = -x_lead_amount
	elif look_direction.x < 0:
		x_lead = x_lead_amount
	y_lead = y_lead_amount


func _cutscene_running_adjustments() -> void:
	if cutscene_running:
		x_target_lead = lerp(x_target_lead, x_cutscene_lead, lerpspeed*3)
	else:
		x_target_lead = lerp(x_target_lead, x_lead, lerpspeed)


func add_trauma(trauma_in):
	trauma = trauma_in


func SCREENSHAKE() -> void:
	add_trauma(0.2)


func BIG_SCREENSHAKE() -> void:
	await get_tree().create_timer(0.05).timeout
	add_trauma(3.0)


func on_big_explosion() -> void:
	flash_screen(0.01, get_node(target).global_position)


func flash_screen(flash_time: float, flash_position: Vector2) -> void:
	var screen_size := get_viewport_rect().size*2
	var color_rect = ColorRect.new()
	color_rect.color = Color.WHITE
	color_rect.set_size(screen_size)
	color_rect.global_position = Vector2(flash_position.x - screen_size.x*0.5, flash_position.y - screen_size.y*0.5)
	get_tree().get_root().add_child(color_rect)
	await get_tree().create_timer(flash_time).timeout
	color_rect.queue_free()


func _on_player_changed_state(new_state: String, _previous_state: String) -> void:
	if new_state == "Dash":
		dashing = true
	if new_state == "Idle" or new_state == "Walk":
		dashing = false


func _on_player_done_syphoning(successful_syphon: bool) ->void:
	if successful_syphon:
		BIG_SCREENSHAKE()


func set_camera_limits():
	var map_limits = $"../LevelEdges".get_used_rect()
	var map_cellsize = $"../LevelEdges".tile_set.tile_size
	limit_left = map_limits.position.x * map_cellsize.x + map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x - map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y - map_cellsize.x
	limit_bottom = map_limits.end.y * map_cellsize.y + map_cellsize.x


func _on_cutscene_start() -> void:
	original_target = target
	cutscene_running = true


func _on_cutscene_end() -> void:
	cutscene_running = false
	target = original_target


func _on_morning_start() -> void:
	freeze_camera = true


func _on_player_die() -> void:
	$AnimationPlayer.play("fade_in")
	freeze_camera = true

func on_change_focus(new_target: Node) -> void:
	target = new_target.get_path()


func _on_body_entered(body) -> void:
	if not body is Enemy:
		return
	body.activate()

func _on_player_changed_falling_state(player_is_falling: bool) -> void:
	if player_is_falling:
		pass
	else:
		pass
