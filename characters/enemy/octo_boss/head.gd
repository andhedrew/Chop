extends Node2D

enum EyeState { IDLE, HURT, ATTACK, DEAD }

var state = EyeState.IDLE
var health = 8
var last_hit_position := Vector2.ZERO
var attacked = false

@onready var hurtbox = $Hurtbox
@onready var sprite = $HeadSprite
@export var aim_rotation = 0
@export var is_left_half := false

func _ready():
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	$"../../StateMachine/Cry1".cry.connect(_on_cry)

func _physics_process(delta):
	if $"../../StateMachine".phase != 1:
		match state:
			EyeState.IDLE:
				hurtbox.set_deferred("monitoring", true)
				sprite.frame = 0
				attacked = false
			EyeState.HURT:
				hurtbox.set_deferred("monitoring", false)
				sprite.frame = 1
			EyeState.ATTACK:
				hurtbox.set_deferred("monitoring", false)
				sprite.frame = 2
				if not attacked:
					attacked = true
					await get_tree().create_timer(0.5).timeout
					attack(last_hit_position)
					
			EyeState.DEAD:
				sprite.frame = 3
	else:
		hurtbox.set_deferred("monitoring", false)

func _on_hurtbox_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		last_hit_position = hitbox.position
		health -= 1
		if health % 3 == 0:
			state = EyeState.HURT
			await get_tree().create_timer(0.3).timeout
			state = EyeState.ATTACK
		else:
			state = EyeState.HURT
			await get_tree().create_timer(0.5).timeout
			state = EyeState.IDLE
		
		if health <= 0:
			state = EyeState.DEAD
			hurtbox.set_deferred("monitoring", false)
			if is_left_half:
				owner.lost_left_eye = true
			else: 
				owner.lost_right_eye = true


func _on_cry():
	if state != EyeState.DEAD:
		state = EyeState.ATTACK
		
func attack(aim_pos: Vector2):
	var bullet_scene = preload("res://bullets/goo_bullet/goo_bullet.tscn")
	var base_rotation = randf_range(aim_rotation-60, aim_rotation+60)
	var rotation_increment = 90 # Adjust this value to control the angle change
	var number_of_sets = 8
	var bullets_per_set = 5
	var spread_angle = 65

	for i in range(number_of_sets):
		for j in range(bullets_per_set):
			var bullet = bullet_scene.instantiate()
			owner.add_child(bullet)
			var rotation = base_rotation + spread_angle * (j - 1) # Adjusts for center, left, and right bullets
			var transform = $Marker2D.global_transform
			var fire_range = 300
			var speed = 120
			var spread = 12
			bullet.setup(transform, fire_range, speed, rotation, spread)

		
		# Modify base rotation for next set to create a wavy pattern
		if i % 2 == 0:
			base_rotation += rotation_increment
		else:
			base_rotation -= rotation_increment

		# Optional delay between sets
		await get_tree().create_timer(0.3).timeout
	
	state = EyeState.IDLE

