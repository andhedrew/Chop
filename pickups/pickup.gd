class_name Pickup
extends CharacterBody2D

@export var floating_pickup : bool = false
@onready var animation_player := $AnimationPlayer as AnimationPlayer
var max_fall_speed := Param.GRAVITY
var sort_layer = SortLayer.IN_FRONT
var conveyor_count := 0
var belt_speed := 0.0


func _ready():
	z_index = sort_layer
	animation_player.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)
	$SlowPickupTimer.start()


func _physics_process(_delta):
	if !is_on_floor():
		velocity.y = lerp(velocity.y, max_fall_speed, 0.1)
	else:
		velocity.y = 1.0
	if floating_pickup:
		velocity = Vector2.ZERO
	apply_friction()
	move_and_slide()


func apply_friction():
	velocity.x = lerp(velocity.x, belt_speed, 0.2)

func _on_body_entered(body) -> void:
	if body is Player and $SlowPickupTimer.is_stopped() and body.state != "Dead":
		_add_pickup_to_inventory(body)
		

func _add_pickup_to_inventory(player) -> void:
	_destroy(player)


func setup(new_texture: CompressedTexture2D) -> void:
	$Sprite2D.texture = new_texture
	var size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = size / 2


func _destroy(player_pos: Vector2) -> void:
	animation_player.play("destroy")
	SoundPlayer.play_sound("pickup")
	set_deferred("monitoring", false)
	position = lerp(position, player_pos, 0.2)
	await get_tree().create_timer(.8).timeout
	queue_free()



func add_conveyor_velocity(belt_velocity) -> void:
	conveyor_count += 1
	print_debug("Convyor Count: " + str(conveyor_count))
	belt_speed = belt_velocity
	print_debug("belt_speed: " + str(belt_speed))

func remove_conveyor_velocity() -> void:
	conveyor_count -= 1
	if conveyor_count <= 0:
		conveyor_count = 0
		belt_speed = 0
