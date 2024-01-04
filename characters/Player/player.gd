# Wilmer Dermeet
extends CharacterBody2D
class_name Player

@export var camera : Camera2D 
@export var death_pieces: Array[Resource]
const max_speed := 120
const acceleration := 9
const acceleration_in_air := 12
const jump_height = -200.0

var current_state := ""
var bullet_hit_breakable := false
var bullet_hit_breakable_position := Vector2.ZERO
var invulnerable := false
var max_health := 6
var health := max_health
var money := 0

var facing := Enums.Facing.RIGHT
var looking := Enums.Looking.FORWARD
var default_facing = facing
var facing_last_frame = facing

var in_water := false

var attack: bool
var jump: bool
var dash: bool
var input: Vector2
var state:= "Idle"
var state_last_frame := state

var bag := []
var bag_capacity := 1000
@export var has_booster_upgrade := false
var torch_charges := 3
var max_torch_charges := torch_charges
@export var automatic_recharge := true
var charge_time := 0.3
var charge_timer := charge_time
var execute_disabled := false
var buffer_execute := false

var set_ui := false

var cutscene_walk := false

var lives := 5

@onready var hurtbox := $Hurtbox
@onready var foot_detector := $Pivot/FootDetector
@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer
@onready var belt_detector := $Pivot/BeltDetector

var knockback_direction : Vector2
var knockback_strength: float = 180.0
var knockback: Vector2

var weapon := Enums.Weapon.BASIC
var bullet = preload("res://bullets/slash_bullet/slash_bullet.tscn")
var bullet_range := 10
var bullet_speed := 150
var bullet_spread := 0
var attack_upward_force := 100
var attack_backward_force := 10
var attack_delay := 0.3

var execute_bullet := preload("res://bullets/execute_bullet/execute_bullet.tscn")
var execute_range := 150
var execute_speed := 3000
var execute_spread := 0

@onready var collider := $CollisionShape2D
@onready var brick_detector_1 := $Pivot/BreakableDetector
@onready var brick_detector_2 := $Pivot/BreakableDetector2

var attack_animation_index := 0
var standing_on_belt := false
var belt_max_speed := 20
var belt_move_speed := belt_max_speed


var belt_speed := 0.0
var conveyor_count = 0

var spider_level_restart := false

var bullet_hit_breakable_count := 0


func _ready():
	if automatic_recharge:
		torch_charges = 0
	hurtbox.area_entered.connect(_hurtbox_on_area_entered)
	GameEvents.enemy_took_damage.connect(_on_enemy_taking_damage)
	GameEvents.morning_started.connect(_on_morning_start)
	GameEvents.continue_day.connect(_on_continue_day)
	GameEvents.SaveDataReady.connect(_load_data)
	GameEvents.feeding_level_start.connect(_feeding_level_start)
	GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)
	GameEvents.refresh_execute.connect(_refresh_execute)
	
	hurtbox.body_shape_entered.connect(_on_hitbox_body_shape_entered)
	hurtbox.body_shape_exited.connect(_on_hitbox_body_shape_exited)
	
	GameEvents.bullet_hit_breakable.connect(_on_bullet_hit_breakable)
	GameEvents.add_a_charge.connect(_on_adding_a_charge)
	
	GameEvents.cheatmode.connect(_on_activating_cheat_mode)
	z_index = SortLayer.PLAYER
	_load_data()


func _load_data() -> void:
	max_health = SaveManager.load_item("health")
	health = max_health
	GameEvents.player_health_changed.emit(health, max_health)
	
	
	var money_amt = SaveManager.load_item("money")
	if money_amt != null:
		money = money_amt
	
	var current_lives = SaveManager.load_item("lives")
	if current_lives != null:
		lives = current_lives
	
	var current_bag = SaveManager.load_item("bag")
	if current_bag != null:
		bag = current_bag
		
	

func _physics_process(delta):
	if !set_ui:
		set_ui = true
		GameEvents.player_health_changed.emit(health, max_health)
		GameEvents.bag_capacity_changed.emit(bag_capacity)
	
	get_input()
	state = $StateMachine.state.name
	_set_debug_labels()
	handle_facing()
	state_last_frame = state
	
	if (torch_charges < max_torch_charges) and automatic_recharge:
		if is_on_floor():
			charge_time -= 1*delta
			if charge_time < 0:
				torch_charges = max_torch_charges
				charge_time = charge_timer
				GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)
	elif not automatic_recharge and is_on_floor():
		torch_charges = 0
		GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)
		
		
	if cutscene_walk:
		if facing == Enums.Facing.RIGHT:
			position.x += 1
		else:
			position.x -= 1
	
	if Input.is_action_just_pressed("unload_bag"):
		drop_last_item()
	


func change_weapon(new_weapon) -> void:
	weapon = new_weapon
	match weapon:
		Enums.Weapon.BASIC:
			$Pivot/Weapon.texture = preload("res://weapons/cleaver.png")
			bullet = preload("res://bullets/slash_bullet/slash_bullet.tscn")
			bullet_range = 10
			bullet_speed = 150
			bullet_spread = 0
			attack_upward_force = 100
			attack_backward_force = 80
			attack_delay = 0.8

			execute_bullet = preload("res://bullets/execute_bullet/execute_bullet.tscn")
			execute_range = 150
			execute_speed = 3000
			execute_spread = 0
			
		Enums.Weapon.FAST:
			$Pivot/Weapon.texture = preload("res://weapons/fast_knife.png")
			bullet = preload("res://bullets/slash_bullet/slash_bullet.tscn")
			bullet_range = 4
			bullet_speed = 250
			bullet_spread = 0
			attack_upward_force = 30
			attack_backward_force = 0
			attack_delay = 0.1

			execute_bullet = preload("res://bullets/execute_bullet/execute_bullet.tscn")
			execute_range = 150
			execute_speed = 3000
			execute_spread = 0
			
		Enums.Weapon.STRONG: pass
		Enums.Weapon.LONG: pass
		Enums.Weapon.CURSED: pass


func drop_last_item() -> void:
	if bag.size() > 0:
		var item = bag.pop_back()
		var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
		pickup.setup(item)
		get_node("/root/World").call_deferred("add_child", pickup)
		pickup.sort_layer = SortLayer.PLAYER
		pickup.position.y = global_position.y - 30
		if facing == Enums.Facing.RIGHT:
			pickup.position.x = global_position.x + 23
		else:
			pickup.position.x = global_position.x - 30
		pickup.velocity = Vector2.ZERO
		GameEvents.removed_food_from_bag.emit(pickup)


func _set_debug_labels() -> void:
	match facing:
		Enums.Facing.LEFT: $Facing.text = "Facing: left"
		Enums.Facing.RIGHT: $Facing.text = "Facing: right"
	$State.text = state
	match looking:
		Enums.Looking.UP: $Looking.text = "Looking: up"
		Enums.Looking.DOWN: $Looking.text = "Looking: down"
		Enums.Looking.FORWARD: $Looking.text = "Looking: forward"


func get_input() -> void:
	attack = Input.is_action_just_pressed("attack")
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	jump =  Input.is_action_just_pressed("jump")
	dash = Input.is_action_pressed("dash")


func handle_facing() -> void:
	if state == "Attack" or state == "Execute" or state == "Hurt" or state == "Cutscene": 
		return
	if input.x > 0:
		facing = Enums.Facing.RIGHT
		default_facing = facing
		

		
	elif input.x < 0:
		facing = Enums.Facing.LEFT
		default_facing = facing
		
	var buff := 6.0
	if input.y == 0:
		looking = Enums.Looking.FORWARD
		brick_detector_1.position = Vector2(-2.0, 14.0)
		brick_detector_1.target_position = Vector2(32.0 + buff, 0.0)
		brick_detector_2.position = Vector2(-2.0, -4.0)
		brick_detector_2.target_position = Vector2(32.0 + buff, 0.0)
	elif input.y < 0:
		looking = Enums.Looking.UP
		$Pivot/BulletSpawn.position = Vector2(0, -20)
		
		brick_detector_1.position = Vector2(6.0, -12.0)
		brick_detector_1.target_position = Vector2(6.0, -16.0 - buff)
		brick_detector_2.position = Vector2(-9.0, -12.0)
		brick_detector_2.target_position = Vector2(0.0, -16.0 - buff)
		
	elif input.y > 0:
		looking = Enums.Looking.DOWN
		$Pivot/BulletSpawn.position = Vector2(0, 20)
		
		brick_detector_1.position = Vector2(6.0, 14.0)
		brick_detector_1.target_position = Vector2(0.0, 16.0 + buff)
		brick_detector_2.position = Vector2(-9.0, -13.0)
		brick_detector_2.target_position = Vector2(0.0, 16.0 + buff)
		
	if facing_last_frame != facing:
		GameEvents.player_changed_facing.emit(facing)
	facing_last_frame = facing
	
	if input.x > 0:
		$Pivot.transform.x.x = 1
	elif input.x < 0:
		$Pivot.transform.x.x = -1
	
	if Input.is_action_pressed("down") and !is_on_floor():
		$Pivot/BulletSpawn.position = Vector2(0, 20)
	else: 
		$Pivot/BulletSpawn.position = Vector2(10, 0)


func _hurtbox_on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if hitbox.lethal:
			take_damage(1000)
	if !invulnerable and hitbox is HitBox:
		print("hit by hitbox")
		print(str(hitbox.lethal))
		knockback_direction = (global_position - hitbox.global_position).normalized()
		knockback = knockback_direction * knockback_strength
		$StateMachine.transition_to("Hurt")
		take_damage(hitbox.damage)


func take_damage(damage) -> void:
	health -= damage
	GameEvents.player_health_changed.emit(health, max_health)
	if health <= 0:
		_die()


func _die() -> void:
	GameEvents.player_died.emit()
	if death_pieces:
		var spread = 16 # adjust this value to increase or decrease the spread of the pickups
		var new_velocity = Vector2(0, -12) # adjust this value to control the initial velocity of the pickups
		var death_pieces_size = death_pieces.size()
		var i = 0
		for sprite in death_pieces:
			var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
			pickup.setup(sprite)
			var angle = i * 2 * PI / death_pieces_size
			i += 1
			pickup.position = global_position + Vector2(cos(angle), sin(angle)) * spread
			pickup.velocity = new_velocity.rotated(angle)
			get_node("/root/World").call_deferred("add_child", pickup)

	OS.delay_msec(80)
	var explode := preload("res://vfx/oil_explosion.tscn").instantiate()
	explode.position = global_position
	explode.emitting = true
	get_node("/root/World").add_child(explode)
	
	explode = preload("res://vfx/explosion.tscn").instantiate()
	explode.position = global_position
	explode.big = true
	get_node("/root/World").add_child(explode)
	queue_free()


func _on_enemy_taking_damage(health) -> void:
	if torch_charges < max_torch_charges:
		SoundPlayer.play_sound("pickup_2")
		torch_charges += 1
		GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges)


func _on_morning_start() -> void:
	has_booster_upgrade = false
	await get_tree().create_timer(3.0).timeout
	$StateMachine.transition_to("Cutscene")
	facing = Enums.Facing.RIGHT
	$Pivot.transform.x.x = 1
	$Pivot.animation_player.play("walk")
	cutscene_walk = true


func _on_continue_day() -> void:
	await get_tree().create_timer(1.0).timeout
	$StateMachine.transition_to("Cutscene")
	facing = Enums.Facing.RIGHT
	$Pivot.transform.x.x = 1
	$Pivot.animation_player.play("walk")
	cutscene_walk = true


func _feeding_level_start() -> void:
	await get_tree().create_timer(1.0).timeout
	$StateMachine.transition_to("Cutscene")
	facing = Enums.Facing.LEFT
	$Pivot.transform.x.x = -1
	$Pivot.animation_player.play("walk")
	cutscene_walk = true
	await get_tree().create_timer(3.0).timeout
	cutscene_walk = false
	GameEvents.cutscene_ended.emit()


func is_in_water() -> void:
	in_water = true


func is_out_of_water() -> void:
	in_water = false


func _on_hitbox_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body is TileMap:
		if body.name == "Water":
			if not body.bad_water:
				is_in_water()
				return

		# Get the cell position of the tile that the player has collided with
		var cell_position = body.local_to_map(global_position)

		# Convert the cell position back to world coordinates, but at the center of the tile
		var tile_center_position = body.map_to_local(cell_position) + Vector2(8.0, 8.0)

		# Calculate the knockback direction based on the tile center position instead of the tilemap origin
		knockback_direction = (global_position - tile_center_position).normalized()

		knockback = knockback_direction * knockback_strength
		$StateMachine.transition_to("Hurt")
		take_damage(1)


func _on_hitbox_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body is TileMap:
		if body.name == "Water":
			is_out_of_water()


func _on_bullet_hit_breakable(bullet_pos: Vector2) -> void:
	bullet_hit_breakable_count += 1
	if brick_detector_1.is_colliding() or brick_detector_2.is_colliding():
		bullet_hit_breakable = true
		bullet_hit_breakable_position = bullet_pos
	
	await get_tree().create_timer(1.5).timeout
	bullet_hit_breakable_count -= 1


func _on_adding_a_charge() -> void:
	if torch_charges < max_torch_charges:
		torch_charges += 1
		GameEvents.charge_amount_changed.emit(torch_charges, max_torch_charges )


func add_conveyor_velocity(belt_velocity) -> void:
	conveyor_count += 1
	belt_speed = belt_velocity

func remove_conveyor_velocity() -> void:
	conveyor_count -= 1
	if conveyor_count <= 0:
		conveyor_count = 0
		belt_speed = 0


func _refresh_execute():
	buffer_execute = true


func _on_activating_cheat_mode():
	has_booster_upgrade = true
	torch_charges = 30
	max_torch_charges = 30


