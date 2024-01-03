extends Camera2D

# Reference to the player node
var player: Node2D
var target: Node2D

var average_with_target: bool = false
var target_node_to_average: Node2D


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

var current_horizontal_offset: float = 0.0
var horizontal_offset_smoothing: float = 2.0

# Screen Shake Variables
var shake_intensity: float = 0.0
var shake_decay: float = 0.1


var freeze := false

func _ready():
	self.enabled = true
	z_index = SortLayer.HUD
	# Assign the player node. Replace 'Player' with the correct node name or path.
	player = get_node_or_null("../Player")
	target = player
	GameEvents.player_attacked.connect(SCREENSHAKE)
	GameEvents.player_executed.connect(BIG_SCREENSHAKE)
	GameEvents.big_explosion.connect(BIG_SCREENSHAKE)
	GameEvents.boss_stomped.connect(BIG_SCREENSHAKE)
	GameEvents.boss_hit_wall.connect(SCREENSHAKE)
	GameEvents.player_died.connect(_on_player_die)
	GameEvents.big_explosion.connect(on_big_explosion)
	GameEvents.camera_change_focus.connect(on_change_focus)
	GameEvents.camera_reset_focus.connect(reset_focus)
	GameEvents.camera_split_focus.connect(set_averaging)
	GameEvents.cutscene_started.connect(_on_cutscene_started)
	GameEvents.cutscene_ended.connect(_on_cutscene_ended)

	set_camera_limits()
	


func set_averaging(target_to_avg: Node2D):
	average_with_target = true
	target_node_to_average = target_to_avg


func _process(delta: float) -> void:
	if player == null:
		return
	
	if target == player and not freeze:
		var player_pos: Vector2 = player.global_position
		var target_pos: Vector2 = target_node_to_average.global_position if target_node_to_average != null else player_pos
		var averaged_position: Vector2

		if average_with_target and target_node_to_average != null:
			# Average the position between the player and the target node
			averaged_position = (player_pos + target_pos) / 2.0
		else:
			# Default to player position
			averaged_position = player_pos

		var horizontal_offset: float = 0.0
		if player.facing == Enums.Facing.RIGHT:
			horizontal_offset = horizontal_look_ahead
		elif player.facing == Enums.Facing.LEFT:
			horizontal_offset = -horizontal_look_ahead

		current_horizontal_offset = lerp(current_horizontal_offset, horizontal_offset, horizontal_offset_smoothing * delta)

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
		var player_global_pos: Vector2 = averaged_position + Vector2(current_horizontal_offset, vertical_offset + vertical_look_offset)


		# Check if the player is outside the deadzone
		if not deadzone_rect.has_point(player_global_pos):
			global_position = lerp(global_position, player_global_pos, follow_speed * delta)
		else:
			var edge_smoothness: float = 0.1
			global_position = lerp(global_position, player_global_pos, edge_smoothness)
	elif not freeze: # Follow a non-player target
		global_position = lerp(global_position, target.global_position, follow_speed * delta)


	if shake_intensity > 0:
		var random_offset: Vector2 = Vector2(randf() * 2.0 - 1.0, randf() * 2.0 - 1.0) * shake_intensity
		global_position += random_offset
		shake_intensity -= shake_decay * delta


func SCREENSHAKE() -> void:
	shake(0.5, 1.0, 2.0)


func BIG_SCREENSHAKE() -> void:
	shake(0.3, 30.0, 5.0)


func shake(duration: float, intensity: float, decay: float):

	shake_intensity = intensity
	shake_decay = decay
	# Optionally, you could use a Timer node to manage the duration of the shake
	var timer: Timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(_on_shake_timer_timeout)
	add_child(timer)
	timer.start()


func set_camera_limits():
	var map_limits = $"../LevelEdges".get_used_rect()
	var map_cellsize = $"../LevelEdges".tile_set.tile_size
	limit_left = map_limits.position.x * map_cellsize.x + map_cellsize.x
	limit_right = map_limits.end.x * map_cellsize.x - map_cellsize.x
	limit_top = map_limits.position.y * map_cellsize.y - map_cellsize.x
	limit_bottom = map_limits.end.y * map_cellsize.y + map_cellsize.x


func _on_shake_timer_timeout():
	shake_intensity = 0.0



func on_big_explosion() -> void:
	flash_screen(0.01, player.global_position)


func flash_screen(flash_time: float, flash_position: Vector2) -> void:
	var screen_size := get_viewport_rect().size*2
	var color_rect = ColorRect.new()
	color_rect.color = Color.WHITE
	color_rect.set_size(screen_size)
	color_rect.global_position = Vector2(flash_position.x - screen_size.x*0.5, flash_position.y - screen_size.y*0.5)
	get_tree().get_root().add_child(color_rect)
	await get_tree().create_timer(flash_time).timeout
	color_rect.queue_free()


func _on_player_die() -> void:
	$AnimationPlayer.play("fade_in")


func on_change_focus(new_target: Node2D) -> void:
	target = new_target


func reset_focus() -> void:
	target = player
	average_with_target = false
	target_node_to_average = null


func _on_cutscene_started():
	freeze = true

func _on_cutscene_ended():
	freeze = false
