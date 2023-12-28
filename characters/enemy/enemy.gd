class_name Enemy
extends CharacterBody2D

@export_category("Properties")
@export var health := 3
var max_health = health
@export var speed := 2.0
var max_x_speed := 30
@export var invulnerable : bool = false
@export var immovable : bool = false

@export_category("Sounds")
@export var hurt_vocalizations: Array[AudioStreamWAV]
@export var death_vocalization: AudioStreamWAV
@export var impact_sound: AudioStreamWAV

@export_category("Drops")
@export var death_pieces: Array[Resource]
@export var bounty: int = 15

@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer
@onready var state_label: Label = $state_label

@onready var pivot := $Pivot

var direction := -1
var facing := Enums.Facing.LEFT
var colliding_hitbox_position : Dictionary
var wounded : bool = false
var has_respawned := false
var player_health_full := true
var reset_effects_player := false
var cutscene_running := false
var active := false
var current_state := ""

var conveyor_count := 0
var belt_speed := 0.0

var lilbro_can_kill := false
var is_pooled := false
var in_a_pool := false
var pool_pos := Vector2.ZERO

func _ready() -> void:
	max_health = health
	$Hurtbox.area_entered.connect(_take_damage)
	$Hurtbox.body_entered.connect(_on_body_entered)

	GameEvents.player_started_syphoning.connect(_on_player_syphoning)
	GameEvents.player_done_syphoning.connect(_on_player_done_syphoning)
	GameEvents.evening_started.connect(_on_end_of_day)
	GameEvents.continue_day.connect(_on_end_of_day)
	GameEvents.player_health_changed.connect(_on_player_health_change)
	GameEvents.cutscene_started.connect(_on_start_cutscene)
	GameEvents.cutscene_ended.connect(_on_end_cutscene)
	set_facing(Enums.Facing.LEFT, false)


func _physics_process(_delta):
	if not active:
		$Hurtbox.set_deferred("Monitoring", false)
		$Hitbox.set_deferred("Monitorable", false)
		return
	
	$Hurtbox.set_deferred("Monitoring", true)
	$Hitbox.set_deferred("Monitorable", true)
	state_label.text = $StateMachine.state.name
	
	if health <= 1:
		wounded = true
	if wounded:
		$BloodParticles.visible = true
		effects_player.play("wounded")
		reset_effects_player = true
	elif reset_effects_player:
		effects_player.play("RESET")
		reset_effects_player = false
	
	
	#scale back to original for squash and stretch
#	if facing == Enums.Facing.RIGHT:
#		if pivot.scale.y != -1:
#			pivot.scale.y = lerp(pivot.scale.y, 1.0, 0.1)
#		if pivot.scale.x != 1:
#			pivot.scale.x = lerp(pivot.scale.x, 1.0, 0.1)
##
#	if facing == Enums.Facing.LEFT:
#		if pivot.scale.y != 1:
#			pivot.scale.y = lerp(pivot.scale.y, 1.0, 0.1)
#		if pivot.scale.x != 1:
#			pivot.scale.x = lerp(pivot.scale.x, 1.0, 0.1)


func set_facing(facing_dir, squash_and_stretch := false) -> void:
	if facing_dir == Enums.Facing.LEFT:
		direction = -1
		$Pivot.scale.x = 1
#		if squash_and_stretch:
#			$Pivot.scale.x = 0.8
#			$Pivot.scale.y = 1.1
		$BloodParticles.transform.x.x = 1
	elif facing_dir == Enums.Facing.RIGHT:
		direction = 1
		$Pivot.scale.x = -1
#		if squash_and_stretch:
#			$Pivot.scale.x = 0.8
#			$Pivot.scale.y = 1.1
		$BloodParticles.transform.x.x = -1
	facing = facing_dir


func switch_facing() -> void:
	
	if facing == Enums.Facing.LEFT:
		facing = Enums.Facing.RIGHT
	elif facing == Enums.Facing.RIGHT:
		facing = Enums.Facing.LEFT
	set_facing(facing, true)


func _take_damage(hitbox) -> void:
	if hitbox is HitBox and !invulnerable:
		
		
		colliding_hitbox_position = {"position": hitbox.owner.get_parent().global_position}
		$StateMachine.transition_to("Hurt", colliding_hitbox_position)
		health -= hitbox.damage
		GameEvents.enemy_took_damage.emit(health)
		if hitbox.lethal:
			die(true, true)
		elif wounded and health <= 0 and hitbox.execute:
			execute()
		elif health <= 0:
			die(false, true, true)
		else:
			var slice = preload("res://vfx/slice.tscn").instantiate()
			slice.position = global_position
			get_node("/root/World").add_child(slice)



func _on_body_entered(body):
	if body.name == "TileMap":
		GameEvents.enemy_took_damage.emit()
		die(false, false, false)


func execute():
	var slice = preload("res://vfx/slice_big.tscn").instantiate()
	slice.position = global_position
	get_node("/root/World").add_child(slice)
	if death_vocalization:
		SoundPlayer.play_sound_positional(death_vocalization, position)
	await get_tree().create_timer(0.2).timeout
	GameEvents.drop_food.emit(death_pieces, Vector2(global_position.x, global_position.y - 5))
	die(true, true, true)


func die(
	was_executed: bool = false, 
	drop_stuff: bool = true,
	was_killed_by_player: bool = false
	) -> void:
	if active:
		SoundPlayer.play_sound_positional(death_vocalization, global_position)
		if was_killed_by_player:
			OS.delay_msec(80)
		var explode := preload("res://vfx/explosion.tscn").instantiate()
		explode.position = global_position
		if was_executed:
			explode.big = true
		elif drop_stuff: # drop stuff
			randomize()
			var options = [1, 2, 3]
			var rand_index: int = randi() % options.size()
			if rand_index == 1:
				pass
			elif rand_index == 2 and not player_health_full:
				GameEvents.drop_health.emit(global_position)
			else:
				GameEvents.drop_coins.emit(bounty, global_position)
				
		get_node("/root/World").add_child(explode)
		
		if get_parent().has_method("respawn"):
			get_parent().respawn() 
		
		if in_a_pool:
			visible = false
			active = false
			position = pool_pos
		else:
			call_deferred("queue_free")

func drop_health_and_die() -> void:
	var explode := preload("res://vfx/blood_explosion.tscn").instantiate()
	explode.position = global_position
	explode.emitting = true
	get_node("/root/World").add_child(explode)
	
	GameEvents.drop_health.emit(global_position)
	
	die(true)


func _on_player_done_syphoning(successful_syphon: bool) -> void:
	if wounded and successful_syphon:
		drop_health_and_die()


func _on_player_syphoning(_player_pos) -> void:
	if wounded:
		$StateMachine.transition_to("Syphoned")


func _on_end_of_day() -> void:
	var particles = preload("res://vfx/despawn_particles.tscn").instantiate()
	get_parent().add_child(particles)
	particles.position = Vector2(0,-5)
	particles.z_index = SortLayer.IN_FRONT
	particles.emitting = true
	$StateMachine.transition_to("Syphoned")
#	queue_free()


func _on_player_health_change(player_health, full_health) -> void:
	if player_health == full_health:
		player_health_full = true
	else:
		player_health_full = false


func _on_start_cutscene() -> void:
	cutscene_running = true


func _on_end_cutscene() -> void:
	cutscene_running =  false


func activate() -> void:
	active = true



func add_conveyor_velocity(belt_velocity) -> void:
	conveyor_count += 1
	belt_speed = belt_velocity

func remove_conveyor_velocity() -> void:
	conveyor_count -= 1
	if conveyor_count <= 0:
		conveyor_count = 0
		belt_speed = 0
