extends Camera2D

# Reference to the player node
var player: Node2D

# Speed of the camera's movement
var follow_speed: float = 5.0

# Size of the deadzone
var deadzone_size: Vector2 = Vector2(100, 100)

# Vertical offset parameters
var is_player_on_ground: bool = false
var vertical_offset: float = 0.0
var offset_speed: float = 0.05

var horizontal_look_ahead: float = 120.0
var vertical_look_ahead: float = 180.0
var up_look_ahead_buffer: float = 120.0


func _ready():
	self.enabled = true
	# Assign the player node. Replace 'Player' with the correct node name or path.
	player = get_node_or_null("../Player")

func _process(delta: float) -> void:
	if player == null:
		return
	
	var horizontal_offset: float = 0.0
	if player.facing == Enums.Facing.RIGHT:
		horizontal_offset = horizontal_look_ahead
	elif player.facing == Enums.Facing.LEFT:
		horizontal_offset = -horizontal_look_ahead
	
	var vertical_look_offset: float = 0.0
	if player.looking == Enums.Looking.UP:
		vertical_look_offset = -vertical_look_ahead + up_look_ahead_buffer   # Negative for looking up
	elif player.looking == Enums.Looking.DOWN:
		vertical_look_offset = vertical_look_ahead


	# Update is_player_on_ground based on your game's logic
	# For example, you might check a variable or call a function in the player script
	is_player_on_ground = player.is_on_floor()

	# Calculate the desired vertical offset
	var target_vertical_offset: float = -get_viewport_rect().size.y / 3 if is_player_on_ground else 0
	vertical_offset = lerp(vertical_offset, target_vertical_offset, offset_speed * delta)

	# Calculate the deadzone
	var deadzone_half: Vector2 = deadzone_size * 0.5
	var deadzone_rect: Rect2 = Rect2(global_position - deadzone_half, deadzone_size)

	# Get the player's global position with vertical offset
	var player_global_pos: Vector2 = player.global_position + Vector2(horizontal_offset, vertical_offset + vertical_look_offset)


	# Check if the player is outside the deadzone
	if not deadzone_rect.has_point(player_global_pos):
		global_position = lerp(global_position, player_global_pos, follow_speed * delta)
	else:
		var edge_smoothness: float = 0.1
		global_position = lerp(global_position, player_global_pos, edge_smoothness)
