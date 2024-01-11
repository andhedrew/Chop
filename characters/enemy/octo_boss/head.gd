extends Node2D

enum EyeState { IDLE, HURT, ATTACK, DEAD }

var state = EyeState.IDLE
var health = 1 #tk7
var last_hit_position := Vector2.ZERO
var attacked = false
@export var wince := false
var wince_timer := 0.0
@onready var hurtbox = $Hurtbox
@onready var sprite = $HeadSprite
@export var aim_rotation = 0
@export var is_left_half := false
var cutscene_running = false
var octo_dead := false
var octo_dead_set_sprite := false

func _ready():
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	GameEvents.octo_dead.connect(_on_dead)
	GameEvents.octo_chopped.connect(_on_dead_chopped)
	if is_left_half:
		$"../../StateMachine/Cry1".cry_left.connect(_on_cry)
		$"../../StateMachine/Cry2".cry_left.connect(_on_cry)
	else:
		$"../../StateMachine/Cry1".cry_right.connect(_on_cry)
		$"../../StateMachine/Cry2".cry_right.connect(_on_cry)
	
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)

func _physics_process(delta):
	if not cutscene_running and not octo_dead:
		if $"../../StateMachine".phase != 1:
			match state:
				EyeState.IDLE:
					hurtbox.set_deferred("monitoring", true)
					if wince:
						sprite.frame = 1
					else:
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
					if wince:
						sprite.frame = 1
					else:
						sprite.frame = 3
		elif not octo_dead:
			hurtbox.set_deferred("monitoring", false)
			match state:
				EyeState.IDLE:
					if wince:
						sprite.frame = 1
					else:
						sprite.frame = 0
					attacked = false
				EyeState.ATTACK:
					sprite.frame = 2
					if not attacked:
						attacked = true
						await get_tree().create_timer(0.5).timeout
						attack(last_hit_position)
	elif octo_dead and not octo_dead_set_sprite:
		sprite.texture = preload("res://characters/enemy/octo_boss/octo_head_dead.png")
		sprite.frame = 0
		octo_dead_set_sprite = true
					

func _on_hurtbox_area_entered(hitbox) -> void:
	if hitbox is HitBox and not octo_dead:
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
				owner.eye_gone["left"] = true
			else: 
				owner.eye_gone["right"] = true


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



func _on_cutscene_start() -> void:
	cutscene_running = true


func _on_cutscene_end() -> void:
	cutscene_running = false


func _on_dead():
	octo_dead = true


func _on_dead_chopped():
	sprite.frame += 1
