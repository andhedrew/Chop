class_name Enemy
extends CharacterBody2D

@export_category("Extra Properties")
@export var health := 3
@export var death_pieces: Array[Resource]
@export_range(0.0, 5.0, 0.5) var erratic_walking_amount := 0.0
@export var hurt_vocalizations: Array[AudioStreamWAV]
@export var death_vocalization: AudioStreamWAV


@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer
@onready var state_label: Label = $state_label

var speed := 20.0
var direction := -1
var facing := Enums.Facing.LEFT
var colliding_hitbox_position : Dictionary

func _ready() -> void:
	$Hurtbox.area_entered.connect(_take_damage)


func _physics_process(_delta):
	var player_check = $Pivot/player_detector.get_collider()
	if player_check is Player:
		print_debug("detecting player")
	
	state_label.text = $StateMachine.state.name
	
	if health <= 0:
		execute()

func _take_damage(hitbox) -> void:
	if hitbox is HitBox:
		colliding_hitbox_position = {1: hitbox.owner.get_parent().global_position}
		$StateMachine.transition_to("Hurt", colliding_hitbox_position)
		health -= hitbox.damage


func set_facing(facing_dir) -> void:
	facing = facing_dir
	if facing == Enums.Facing.LEFT:
		direction = -1
		$Pivot.transform.x.x = 1
	elif facing == Enums.Facing.RIGHT:
		direction = 1
		$Pivot.transform.x.x = -1


func switch_facing() -> void:
	if facing == Enums.Facing.LEFT:
		facing = Enums.Facing.RIGHT
	elif facing == Enums.Facing.RIGHT:
		facing = Enums.Facing.LEFT
	set_facing(facing)


func execute():
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
	die()


func die() -> void:
	call_deferred("queue_free")
