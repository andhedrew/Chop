class_name Enemy
extends CharacterBody2D

@export_category("Properties")
@export var health := 3
var max_health = health
@export var speed := 20.0
@export var invulnerable : bool = false
@export var immovable : bool = false

@export_category("Sounds")
@export var hurt_vocalizations: Array[AudioStreamWAV]
@export var death_vocalization: AudioStreamWAV
@export var impact_sound: AudioStreamWAV

@export_category("Sprites")
@export var death_pieces: Array[Resource]

@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer
@onready var state_label: Label = $state_label

var direction := -1
var facing := Enums.Facing.LEFT
var colliding_hitbox_position : Dictionary
var wounded : bool = false


func _ready() -> void:
	max_health = health
	$Hurtbox.area_entered.connect(_take_damage)
	GameEvents.player_started_syphoning.connect(_on_player_syphoning)
	GameEvents.player_done_syphoning.connect(_on_player_done_syphoning)
	GameEvents.evening_started.connect(_on_end_of_day)
	


func _physics_process(_delta):
	state_label.text = $StateMachine.state.name
	
	if health <= 1:
		wounded = true
	if wounded:
		$BloodParticles.visible = true
		effects_player.play("wounded")
	else:
		effects_player.play("RESET")


func _take_damage(hitbox) -> void:
	if hitbox is HitBox and !invulnerable:
		GameEvents.enemy_took_damage.emit()
		colliding_hitbox_position = {"position": hitbox.owner.get_parent().global_position}
		$StateMachine.transition_to("Hurt", colliding_hitbox_position)
		health -= hitbox.damage
		if wounded and health <= 0 and hitbox.execute:
			execute()
		elif health <= 0:
			die(false)
		else:
			var slice = preload("res://vfx/slice.tscn").instantiate()
			slice.position = global_position
			get_node("/root/").add_child(slice)
			


func set_facing(facing_dir) -> void:
	facing = facing_dir
	if facing == Enums.Facing.LEFT:
		direction = -1
		$Pivot.transform.x.x = 1
		$BloodParticles.transform.x.x = 1
	elif facing == Enums.Facing.RIGHT:
		direction = 1
		$Pivot.transform.x.x = -1
		$BloodParticles.transform.x.x = -1


func switch_facing() -> void:
	if facing == Enums.Facing.LEFT:
		facing = Enums.Facing.RIGHT
	elif facing == Enums.Facing.RIGHT:
		facing = Enums.Facing.LEFT
	set_facing(facing)


func execute():
	var slice = preload("res://vfx/slice_big.tscn").instantiate()
	slice.position = global_position
	get_node("/root/").add_child(slice)
	if death_vocalization:
		SoundPlayer.play_sound(death_vocalization)
		
	await get_tree().create_timer(0.2).timeout
	if death_pieces:
		var spacing = 2
		var starting_x = (death_pieces.size()*(spacing*.5))
		for sprite in death_pieces:
			var pickup := preload("res://pickups/food_pickup.tscn").instantiate()
			pickup.setup(sprite)
			pickup.position = global_position
			pickup.velocity = Vector2(starting_x, randf_range(-4, -6))
			starting_x -= spacing
			get_node("/root/World").add_child(pickup)
		
	die(true)


func die(was_executed: bool = false) -> void:
	OS.delay_msec(80)
	var explode := preload("res://vfx/explosion.tscn").instantiate()
	explode.position = global_position
	if was_executed:
		explode.big = true
	get_node("/root/").add_child(explode)
	get_parent().respawn()
	queue_free()
	

func drop_health_and_die() -> void:
	var explode := preload("res://vfx/blood_explosion.tscn").instantiate()
	explode.position = global_position
	explode.restart()
	explode.emitting = true
	get_node("/root/").add_child(explode)
	
	var sprite := preload("res://user_interface/health bar/full_heart.png")
	var pickup := preload("res://pickups/health_pickup.tscn").instantiate()
	pickup.setup(sprite)
	pickup.position = global_position
	get_node("/root/").call_deferred("add_child", pickup)
	
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
	particles.global_position = get_parent().position
	particles.z_index = SortLayer.IN_FRONT
	particles.emitting = true
	$StateMachine.transition_to("Syphoned")
	await get_tree().create_timer(0.3).timeout
	queue_free()
