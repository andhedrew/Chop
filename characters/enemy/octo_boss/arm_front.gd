extends Node2D

enum ArmState { IDLE, HURT, ATTACK, DEAD }

var state = ArmState.IDLE
var health = 1
var last_hit_position := Vector2.ZERO
var attacked = false

@onready var hurtbox = $Hurtbox
@export var aim_rotation = 0
@export var is_left_half := false
@onready var animation_player = $"../AnimationPlayer2"

func _ready():
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	hurtbox.set_deferred("monitoring", false)

func _physics_process(delta):
	
	match state:
		ArmState.IDLE:
			pass
		ArmState.HURT:
			pass

		ArmState.DEAD:
			queue_free()


func _on_hurtbox_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if !hitbox.execute:
			animation_player.play("hurt")
			health -= 1
			if health <= 0:
				state = ArmState.DEAD
				hurtbox.set_deferred("monitoring", false)
				if is_left_half:
					owner.arm_gone["left"] = true
				else: 
					owner.arm_gone["right"] = true
			else:
				state = ArmState.HURT



