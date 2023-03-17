class_name Enemy
extends CharacterBody2D

@export var health := 3
@export var invulnerable := false

@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer
@onready var state_label: Label = $state_label

var speed := 20.0
var direction := -1
var facing := Enums.Facing.LEFT
var colliding_hitbox_position : Dictionary


func _ready() -> void:
	if invulnerable:
		$Hurtbox.area_entered.connect(_deflect)
	else:
		$Hurtbox.area_entered.connect(_take_damage)


func _physics_process(delta):
	var player_check = $player_detector.get_collider()
	if player_check is Player:
		print_debug("detecting player")
	
	state_label.text = $StateMachine.state.name

func _take_damage(hitbox) -> void:
	if hitbox is HitBox:
		colliding_hitbox_position = {1: hitbox.owner.get_parent().global_position}
		$StateMachine.transition_to("Hurt", colliding_hitbox_position)
		health -= hitbox.damage


func _deflect(hitbox) -> void:
	#$StateMachine.transition_to("Deflect")
	pass #play deflected VFX


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
	
