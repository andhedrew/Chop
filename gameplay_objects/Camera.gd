extends Camera2D

@export var target: NodePath = ""
@export var lerpspeed: float = 0.05
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

var y_lead_amount := -70.0
var y_peek_amount := -70.0
var y_lead := y_lead_amount
var y_target_lead := y_lead

var noise := FastNoiseLite.new()

var time := 0
var target_node: Node
var dashing := false

var setup_letterbox := false
var letterbox_bar_1
var letterbox_bar_2

var freeze_camera := false
 
func _ready():
	noise.noise_type =  FastNoiseLite.TYPE_SIMPLEX
	GameEvents.player_attacked.connect(SCREENSHAKE)
	GameEvents.player_executed.connect(BIG_SCREENSHAKE)
	GameEvents.player_changed_state.connect(_on_player_changed_state)
	GameEvents.player_done_syphoning.connect(_on_player_done_syphoning)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	GameEvents.morning_started.connect(_on_morning_start)
	set_camera_limits()


func _process(delta):
	if !freeze_camera:
		if cutscene_running:
			x_target_lead = lerp(x_target_lead, x_cutscene_lead, lerpspeed*3)
		else:
			x_target_lead = lerp(x_target_lead, x_lead, lerpspeed)
		y_target_lead = lerp(y_target_lead, y_lead, lerpspeed)
		target_node = get_node(target)
		position = lerp(position, Vector2(target_node.position.x+x_target_lead, target_node.position.y+y_target_lead), lerpspeed)

		time += delta
		
		if !dashing:
			var look_direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()

			if look_direction.x > 0:
				x_lead = -x_lead_amount
			elif look_direction.x < 0:
				x_lead = x_lead_amount
			y_lead = y_lead_amount
		else:
			var look_direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()

			if look_direction.x > 0:
				x_lead = -x_lead_amount
			elif look_direction.x < 0:
				x_lead = x_lead_amount

			y_lead = 0


		set_offset(Vector2( \
			randf_range(-1, 1) * trauma, \
			randf_range(-1, 1) * trauma \
		))
		position.x = position.x + randf_range(-max_r, max_r) * trauma
		position.y = position.y + randf_range(-max_r, max_r) * trauma
		trauma = lerp(trauma, 0.0, 0.1)


func add_trauma(trauma_in):
	trauma = trauma_in


func SCREENSHAKE() -> void:
	add_trauma(0.2)


func BIG_SCREENSHAKE() -> void:
	await get_tree().create_timer(0.05).timeout
	add_trauma(3.0)


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
	var map_limits = $"../TileMap".get_used_rect()
	var map_cellsize = $"../TileMap".tile_set.tile_size
	limit_left = map_limits.position.x * map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y
	limit_bottom = map_limits.end.y * map_cellsize.y


func _on_cutscene_start() -> void:
	cutscene_running = true



func _on_cutscene_end() -> void:
	cutscene_running = false


func _on_morning_start() -> void:
	freeze_camera = true
