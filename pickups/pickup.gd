class_name Pickup
extends CharacterBody2D

@onready var animation_player := $AnimationPlayer as AnimationPlayer
var max_fall_speed := 2
var sort_layer = SortLayer.IN_FRONT

func _ready():
	z_index = sort_layer
	animation_player.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)
	$SlowPickupTimer.start()

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += Param.GRAVITY*delta
		velocity.y = min(velocity.y, max_fall_speed)
	else:
		velocity.y = 0
		apply_friction()
	move_and_collide(velocity)


func _on_body_entered(body) -> void:
	if body is Player and $SlowPickupTimer.is_stopped() and body.state != "Dead":
		_add_pickup_to_inventory(body)
		animation_player.play("destroy")
		SoundPlayer.play_sound("pickup")
		set_deferred("monitoring", false)
		position = lerp(position, body.position, 0.2)
		await get_tree().create_timer(.8).timeout
		queue_free()

func _add_pickup_to_inventory(_player) -> void:
	pass


func apply_friction():
	velocity.x = move_toward(velocity.x, 0.0, Param.FRICTION)


func setup(new_texture: CompressedTexture2D) -> void:
	$Sprite2D.texture = new_texture
	var size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = size / 2
