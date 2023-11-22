extends Node2D

enum EyeState { IDLE, HURT, ATTACK, DEAD }

var state = EyeState.IDLE
var health = 8
var last_hit_position := Vector2.ZERO
var attacked = false

@onready var hurtbox = $Hurtbox
@onready var sprite = $HeadSprite
@export var aim_rotation = 0

func _ready():
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)

func _physics_process(delta):
	match state:
		EyeState.IDLE:
			hurtbox.monitoring = true
			sprite.frame = 0
			attacked = false
		EyeState.HURT:
			hurtbox.monitoring = false
			sprite.frame = 1
		EyeState.ATTACK:
			hurtbox.monitoring = false
			sprite.frame = 2
			if not attacked:
				attacked = true
				await get_tree().create_timer(0.5).timeout
				attack(last_hit_position)
				
		EyeState.DEAD:
			pass

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

func attack(aim_pos: Vector2):
	var bullet_scene = preload("res://bullets/goo_bullet/goo_bullet.tscn")
	var base_rotation = aim_rotation
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

