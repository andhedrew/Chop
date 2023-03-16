class_name Enemy
extends CharacterBody2D

@export var health := 3
@export var invulnerable := false

@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer

var speed := 20.0
var direction := 1
var facing := Enums.Facing.RIGHT


func _ready() -> void:
	if invulnerable:
		$Hurtbox.area_entered.connect(_deflect)
	else:
		$Hurtbox.area_entered.connect(_take_damage)


func _physics_process(delta):
	var player_check = $player_detector.get_collider()
	if player_check is Player:
		print_debug("detecting player")

func _take_damage(hitbox) -> void:
	if hitbox is HitBox and $StateMachine.state.name != "Hurt":
		var hitbox_position : Dictionary = {1:hitbox.global_position}
		$StateMachine.transition_to("Hurt", hitbox_position )
		health -= hitbox.damage


func _deflect(hitbox) -> void:
	$StateMachine.transition_to("Deflect")
	pass #play deflected VFX


func set_facing(facing_dir) -> void:
	facing = facing_dir
	if facing == Enums.Facing.LEFT:
		direction = -1
		transform.x.x = -1
	elif facing == Enums.Facing.RIGHT:
		direction = 1
		transform.x.x = 1


func switch_facing() -> void:
	if facing == Enums.Facing.LEFT:
		facing = Enums.Facing.RIGHT
	elif facing == Enums.Facing.RIGHT:
		facing = Enums.Facing.LEFT
	set_facing(facing)
	
