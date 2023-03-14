extends Camera2D

@export var target: NodePath = ""
@export var lerpspeed: float = 0.05
var lead_amount := 150.0
var lead := lead_amount
var target_lead := lead

var noise := FastNoiseLite.new()
@export var trauma: float = 0.0
@export var max_x := 150
@export var max_y := 150
@export var max_r := 25
@export var time_scale := 150.0
@export var decay: float = 0.6
var time := 0
var target_node: Node

 
func _ready():
	noise.noise_type =  0
	GameEvents.player_changed_facing.connect(_change_lead_position)
	GameEvents.player_attacked.connect(SCREENSHAKE)
	GameEvents.player_executed.connect(BIG_SCREENSHAKE)


func _process(delta):
	target_lead = lerp(target_lead, lead, 0.02)
	target_node = get_node(target)
	position = lerp(position, Vector2(target_node.position.x+target_lead, target_node.position.y), lerpspeed)
	time += delta

	set_offset(Vector2( \
		randf_range(-1, 1) * trauma, \
		randf_range(-1, 1) * trauma \
	))
	rotation_degrees = randf_range(-max_r, max_r) * trauma
#	offset.x = noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
#	offset.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
#	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	trauma = lerp(trauma, 0.0, 0.1)
 

func _change_lead_position(player_facing_dir) -> void:
	match player_facing_dir:
		Enums.Facing.RIGHT: lead = lead_amount
		Enums.Facing.LEFT: lead = -lead_amount



func add_trauma(trauma_in):
	trauma = trauma_in


func SCREENSHAKE() -> void:
	add_trauma(50)


func BIG_SCREENSHAKE() -> void:
	await get_tree().create_timer(0.2).timeout
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

