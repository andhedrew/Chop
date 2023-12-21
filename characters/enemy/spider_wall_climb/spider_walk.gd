extends WalkerWalk


@onready var ceiling_check := $"../../ceiling_check"  # Added ceiling check
@onready var floor_check := $"../../floor_check"
var crawling := false
var crawl_direction := Vector2(1, 0)  # Direction the character is crawling in



enum Surface {FLOOR, LEFT_WALL, RIGHT_WALL, CEILING}
var current_surface = Surface.FLOOR

var target_rotation := 0.0
var jump_timer := randf_range(1.0, 4.0)

func enter(_msg := {}) -> void:
	super.enter()
	if randf() < 0.5:
		owner.switch_facing()
	jump_timer = randf_range(1.0, 4.0)
	

func _ready():
	owner.lilbro_can_kill = true
	

func physics_update(delta: float) -> void:
	# Check for walls and ceiling
	var wall_hit_left = wall_left.is_colliding()
	var wall_hit_right = wall_right.is_colliding()
	var ceiling_hit = ceiling_check.is_colliding()
	var floor_hit = floor_check.is_colliding()
	var ledge_check_l = ledge_left.is_colliding()
	var ledge_check_r = ledge_right.is_colliding()

	# Update current surface based on collisions
	if ceiling_hit and current_surface != Surface.CEILING:
		current_surface = Surface.CEILING
	elif wall_hit_left and current_surface != Surface.LEFT_WALL:
		current_surface = Surface.LEFT_WALL
	elif wall_hit_right and current_surface != Surface.RIGHT_WALL:
		current_surface = Surface.RIGHT_WALL
	elif floor_hit and current_surface != Surface.FLOOR:
		current_surface = Surface.FLOOR
	
	
	var facing = 0
	match owner.facing:
		Enums.Facing.RIGHT:
			facing = -1
		Enums.Facing.LEFT:
			facing = 1
	
	
	if not wall_hit_left and not wall_hit_right and not ceiling_hit and not floor_hit:
		if not ledge_check_l and not ledge_check_r:
			state_machine.transition_to("Fall")
		elif ledge_check_l:
			if facing == 1:
				current_surface = Surface.FLOOR
			else:
				current_surface = Surface.LEFT_WALL
		elif ledge_check_r:
			if facing == 1:
				current_surface = Surface.RIGHT_WALL
			else:
				current_surface = Surface.FLOOR
	
	match current_surface:
		Surface.CEILING:
			crawl_direction = Vector2(owner.speed * facing, 0)  # Horizontal crawling on ceiling
		Surface.LEFT_WALL:
			crawl_direction = Vector2(0, -owner.speed * facing)  # Crawling up on left wall
		Surface.RIGHT_WALL:
			crawl_direction = Vector2(0, owner.speed * facing)  # Crawling up on right wall
		Surface.FLOOR:
			crawl_direction = Vector2(-owner.speed * facing, 0)  # Regular horizontal walking
			
	
	
	# Apply crawling or walking velocity
	if abs(owner.velocity.dot(crawl_direction)) <= owner.max_x_speed:
		owner.velocity += crawl_direction * owner.speed
	else:
		owner.velocity = crawl_direction * owner.max_x_speed
	
	owner.move_and_slide()
	
	if player_detector.is_colliding() and current_surface == Surface.CEILING:
		owner.pivot.rotation_degrees = 0
		state_machine.transition_to("Fall")
	
	jump_timer -= delta
	if jump_timer < 0.0 and current_surface == Surface.FLOOR:
		state_machine.transition_to("Attack")



func exit() -> void:
	crawling = false
