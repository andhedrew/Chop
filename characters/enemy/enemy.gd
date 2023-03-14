class_name Enemy
extends CharacterBody2D

@export var health := 3
var speed := 20.0
var direction := 1

func _ready() -> void:
	$Hurtbox.area_entered.connect(_take_damage)


func _take_damage(hitbox) -> void:
	if hitbox is HitBox:
		queue_free()
