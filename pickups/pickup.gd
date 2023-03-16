class_name Pickup
extends CharacterBody2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer
var pickup_texture
var max_fall_speed := 2


func _ready():
	z_index = SortLayer.IN_FRONT
	animation_player.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)
	if pickup_texture:
		$Sprite.texture = pickup_texture
	$SlowPickupTimer.start()

func _physics_process(delta):
	velocity.y += Param.GRAVITY*delta
	velocity.y = min(velocity.y, max_fall_speed)
	move_and_collide(velocity)
	if is_on_floor():
		apply_friction()

func _on_body_entered(body) -> void:
	if body is Player and $SlowPickupTimer.is_stopped() and body.state != "Dead":
		_add_pickup_to_inventory(body)
		animation_player.play("destroy")
#		SoundPlayer.play_sound("pickup")
		set_deferred("monitoring", false)
		

func _add_pickup_to_inventory(_player) -> void:
	pass


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, Param.FRICTION)
