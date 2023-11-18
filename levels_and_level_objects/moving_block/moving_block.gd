extends CharacterBody2D

var speed = 100
var move_direction = Vector2(0, 1)
var pause_duration = 0.5
var is_paused = false
var pause_timer = 0.0

@export_enum("counter-clockwise", "clockwise", "up-and-down", "side-to-side") var patrol := "counter-clockwise"

var checking_for := "floor"
var state_map = {
	"counter-clockwise": {
		"floor": {"next": "wall_right", "angle": -90},
		"wall_right": {"next": "ceiling", "angle": -90},
		"ceiling": {"next": "wall_left", "angle": -90},
		"wall_left": {"next": "floor", "angle": -90}
	},
	"clockwise": {
		"floor": {"next": "wall_left", "angle": 90},
		"wall_left": {"next": "ceiling", "angle": 90},
		"ceiling": {"next": "wall_right", "angle": 90},
		"wall_right": {"next": "floor", "angle": 90}
	},
	"up-and-down": {
		"floor": {"next": "ceiling", "angle": 180},
		"ceiling": {"next": "floor", "angle": 180}
	},
	"side-to-side": {
		"wall_left": {"next": "wall_right", "angle": 180},
		"wall_right": {"next": "wall_left", "angle": 180}
	}
}

func _ready():
	if patrol == "side-to-side":
		checking_for = "wall_right"
		move_direction = Vector2(1, 0)


func _physics_process(delta):
	if is_paused:
		handle_pause(delta)
	else:
		velocity = move_direction * speed
		move_and_slide()
		check_collision()
	
	_restore_sprite_size()

func check_collision():
	if (checking_for == "floor" and is_on_floor()) or \
	   (checking_for == "wall_right" and is_on_wall()) or \
	   (checking_for == "wall_left" and is_on_wall()) or \
	   (checking_for == "ceiling" and is_on_ceiling()):
		_on_body_entered()

func _on_body_entered():
	is_paused = true
	pause_timer = pause_duration
	change_direction_and_state()

func change_direction_and_state():
	var state_info = state_map[patrol][checking_for]
	move_direction = move_direction.rotated(deg_to_rad(state_info["angle"]))
	apply_overlap_and_scale_adjustment()
	checking_for = state_info["next"]

func apply_overlap_and_scale_adjustment():
	var overlap_amount := 8
	var squish_amount := 0.9
	var stretch_amount := 1.1
	match checking_for:
		"floor", "ceiling":
			$Body.position.y += overlap_amount if checking_for == "floor" else -overlap_amount
			$Body.scale = Vector2(stretch_amount, squish_amount)
		"wall_right", "wall_left":
			$Body.position.x += overlap_amount if checking_for == "wall_right" else -overlap_amount
			$Body.scale = Vector2(squish_amount, stretch_amount)

func handle_pause(delta):
	pause_timer -= delta
	if pause_timer <= 0:
		is_paused = false


func _restore_sprite_size():
	if $Body.position != Vector2.ZERO:
		$Body.position = lerp($Body.position, Vector2.ZERO, 0.2)

	if $Body.scale != Vector2(1, 1):
		$Body.scale = lerp($Body.scale, Vector2(1, 1), 0.2)
