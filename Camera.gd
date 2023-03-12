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
	GameEvents.player_attacked.connect(_SCREENSHAKE)
	GameEvents.player_executed.connect(_BIG_SCREENSHAKE)


func _process(delta):
	target_lead = lerp(target_lead, lead, 0.02)
	target_node = get_node(target)
	position = lerp(position, Vector2(target_node.position.x+target_lead, target_node.position.y), lerpspeed)
	time += delta

	var shake = pow(trauma, 2)
	offset.x = noise.get_noise_3d(time * time_scale, 0, 0) * max_x * shake
	offset.y = noise.get_noise_3d(0, time * time_scale, 0) * max_y * shake
	rotation_degrees = noise.get_noise_3d(0, 0, time * time_scale) * max_r * shake
	
	if trauma > 0: trauma = clamp(trauma - (delta * decay), 0, 1)
	
 

func _change_lead_position(player_facing_dir) -> void:
	match player_facing_dir:
		Enums.Facing.RIGHT: lead = lead_amount
		Enums.Facing.LEFT: lead = -lead_amount



func add_trauma(trauma_in):
	trauma = clamp(trauma + trauma_in, 0, .8)


func _SCREENSHAKE() -> void:
	add_trauma(0.2)


func _BIG_SCREENSHAKE() -> void:
	await get_tree().create_timer(0.2).timeout
	add_trauma(1.5)


