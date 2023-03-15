class_name Enemy
extends CharacterBody2D

@export var health := 3
@export var invulnerable := false

@onready var animation_player := $Pivot/AnimationPlayer
@onready var effects_player := $Pivot/EffectsPlayer

var speed := 20.0
var direction := 1


func _ready() -> void:
	if invulnerable:
		$Hurtbox.area_entered.connect(_deflect)
	else:
		$Hurtbox.area_entered.connect(_take_damage)


func _take_damage(hitbox) -> void:
	if hitbox is HitBox and $StateMachine.state.name != "Hurt":
		var hitbox_position : Dictionary = {1:hitbox.global_position}
		$StateMachine.transition_to("Hurt", hitbox_position )
		health -= hitbox.damage


func _deflect(hitbox) -> void:
	$StateMachine.transition_to("Deflect")
	pass #play deflected VFX
