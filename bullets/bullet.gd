class_name Bullet
extends Area2D

var default_speed := 200
var travelled_distance := 0
var max_range := 300
var speed := 200
var spread := 0

func _init():
	set_as_top_level(true)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var motion : Vector2 = transform.x * speed * delta
	
	position += motion
	travelled_distance += speed * delta
	if travelled_distance > max_range:
		_destroy()


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
	rotation = new_rotation
	spread = new_spread


func _destroy() -> void:
	queue_free()
	pass
