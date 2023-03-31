extends Camera2D

@export var target: NodePath = ""
@export var lerpspeed: float = 0.05
var x_lead_amount := 150.0
var x_lead := x_lead_amount
var x_target_lead := x_lead

var y_lead_amount := -70.0
var y_peek_amount := -70.0
var y_lead := y_lead_amount
var y_target_lead := y_lead

var noise := FastNoiseLite.new()
@export var trauma: float = 0.0
@export var max_x := 150
@export var max_y := 150
@export var max_r := 25
@export var time_scale := 150.0
@export var decay: float = 0.6
var time := 0
var target_node: Node
var dashing := false

 
func _ready():
	noise.noise_type =  FastNoiseLite.TYPE_SIMPLEX
	GameEvents.player_attacked.connect(SCREENSHAKE)
	GameEvents.player_executed.connect(BIG_SCREENSHAKE)
	GameEvents.player_changed_state.connect(_on_player_changed_state)


func _process(delta):
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
	rotation_degrees = randf_range(-max_r, max_r) * trauma
	trauma = lerp(trauma, 0.0, 0.1)


func add_trauma(trauma_in):
	trauma = trauma_in


func SCREENSHAKE() -> void:
	add_trauma(20)


func BIG_SCREENSHAKE() -> void:
	await get_tree().create_timer(0.05).timeout
	add_trauma(100)


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
	
