extends State

@export var my_bullet : PackedScene = preload("res://bullets/nut_bullet/nut_bullet.tscn")
var timer : Timer
@export var speed := 150
@export var lifetime := 80
@export var attack_sound: AudioStreamWAV

func enter(_msg := {}) -> void:
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.8
	timer.one_shot = true
	timer.start()
	owner.animation_player.play("attack")
	await get_tree().create_timer(0.25).timeout
	if owner.is_on_floor():
		var bullet = my_bullet.instantiate()
		get_node("/root/World/").add_child(bullet)
		var transform : Transform2D = $"../../Pivot/BulletSpawn".global_transform
		var fire_range := lifetime
		var bullet_speed := 150
		var spread := 0
		var rotation := 0
		if owner.facing == Enums.Facing.LEFT:
			rotation = 180
		bullet.setup(transform, fire_range, bullet_speed, rotation, spread)
		var pos = transform.origin
		SoundPlayer.play_sound_positional(attack_sound, pos)
	



func handle_input(_event: InputEvent) -> void:
	pass

func physics_update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	if timer:
		if timer.is_stopped():
			if owner.is_on_floor():
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Fall")


func exit() -> void:
	timer.queue_free()


