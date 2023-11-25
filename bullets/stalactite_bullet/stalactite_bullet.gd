extends Area2D

var default_speed := 500
var travelled_distance := 0
var max_range := 300.0
var speed := 500
var spread := 0
var triggered_destroy := false
@export var big_explosion := false

func _init():
	set_as_top_level(true)

var lifetime := 0.0

var hazard := false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(on_body_entered)
	$AnimationPlayer.play("bullet_enter")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("animate_bullet")
	monitorable = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var motion : Vector2 = transform.x * speed * delta
	position += motion
	monitorable = true
	if hazard:
		$Sprite2D.visible = false
		$SpriteHazard.visible = true
	else:
		$Sprite2D.visible = true
		$SpriteHazard.visible = false



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


func on_body_entered(body):
	if body is TileMap:
		_destroy()

func _destroy() -> void:
	
	var pos_adj := Vector2(global_position.x, global_position.y + 8.0)
	GameEvents.new_vfx.emit("res://vfx/dirt_explode.tscn", global_position)
	if big_explosion:
		GameEvents.new_vfx.emit("res://vfx/explosion_big.tscn", pos_adj)
	else:
		GameEvents.new_vfx.emit("res://vfx/explosion.tscn", pos_adj)
	queue_free()

