extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"
@onready var camera: Camera2D


func enter(_msg := {}) -> void:
	camera = owner.camera
	owner.velocity.y = 0
	await get_tree().create_timer(0.25).timeout
	camera.flash_screen(0.01, owner.global_position)
	fire()
	camera.SCREENSHAKE()
	owner.velocity.y = -80
	SoundPlayer.play_sound("punch")
	SoundPlayer.play_sound("swoosh")


func physics_update(delta: float) -> void:
	var input_direction_x: float = (
		Input.get_action_strength("right")
		- Input.get_action_strength("left")
	)
	owner.velocity.x = move_toward(owner.velocity.x, (owner.max_speed*0.25) * input_direction_x, owner.acceleration_in_air)
	owner.velocity.y += (Param.GRAVITY_ON_FALL*0.25) * delta
	owner.move_and_slide()
	
	
	await animation_player.animation_finished
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	else: 
		state_machine.transition_to("Fall")



func fire() -> void:
	var bullet = preload("res://bullets/execute_bullet/execute_bullet.tscn").instantiate()
	add_child(bullet)
	var transform = $"../../Pivot/BulletSpawn".global_transform
	var fire_range := 150
	var speed := 1000
	var spread := 0
	var rotation := 0
	rotation = 90
	bullet.setup(transform, fire_range, speed, rotation, spread)
