extends State

var reload_time := 5.0
var reloading := false
var reload_timer := 0
@onready var animation_player := $"../../Pivot/AnimationPlayer"

func enter(_msg := {}) -> void:
	var bullet = preload("res://bullets/slash_bullet.tscn").instantiate()
	add_child(bullet)
	var transform = $"../../Pivot".global_transform
	var fire_range := 50
	var speed := 50
	var spread := 0
	var rotation := 0
	if owner.looking == Enums.Looking.UP:
		rotation = 270
	
	if owner.facing == Enums.Facing.LEFT:
		rotation = 180
	bullet.setup(transform, fire_range, speed, rotation, spread)


func physics_update(delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.velocity.y += Param.GRAVITY * delta
	owner.move_and_slide()
	await animation_player.animation_finished
	state_machine.transition_to("Fall")


