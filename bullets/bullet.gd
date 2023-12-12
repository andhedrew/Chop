class_name Bullet
extends Area2D

@export var exploding_bullet := false
var default_speed := 500
var travelled_distance := 0
var max_range := 300.0
var speed := 500
var spread := 0
var triggered_destroy := false
func _init():
	set_as_top_level(true)


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("bullet_enter")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("animate_bullet")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var motion : Vector2 = transform.x * speed * delta
	if ! triggered_destroy:
		position += motion
	travelled_distance += speed * delta
	if travelled_distance > max_range and not triggered_destroy:
		_destroy()
		triggered_destroy = true


func setup(
	new_global_transform: Transform2D,
	new_range: float,
	new_speed:= default_speed,
	new_rotation := 0,
	new_spread := 0
) -> void:
	transform = new_global_transform
	max_range = new_range
	speed = new_speed
	rotation_degrees = new_rotation
	spread = new_spread


func _destroy() -> void:
	if exploding_bullet:
		var explode := preload("res://vfx/explosion.tscn").instantiate()
		explode.position = global_position
		get_node("/root/World").add_child(explode)
	$Hitbox.set_deferred("monitorable", false)
	$AnimationPlayer.play("bullet_exit")
	await $AnimationPlayer.animation_finished
	queue_free()
	pass

