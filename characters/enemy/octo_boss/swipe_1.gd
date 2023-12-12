extends State

var initial_x_offset = 300
var x_offset_decrement = 40
func enter(msg := {}) -> void:
	await get_tree().create_timer(0.3).timeout
	match msg["arm"]:
		"left":
			$"../../AnimationPlayer".play("swipe_arm_left")
			initial_x_offset = 300
			x_offset_decrement = 40
		"right":
			$"../../AnimationPlayer".play("swipe_arm_right")
			initial_x_offset = -300
			x_offset_decrement = -40
	
	await get_tree().create_timer(2.0).timeout
	
	var random_number = randf_range(3, 7)
	for i in range(9):
		GameEvents.boss_hit_wall.emit()
		var bullet = preload("res://bullets/lightning_bullet/lightning_bullet.tscn").instantiate()
		if i != round(random_number):
			owner.add_child(bullet)
		var transform = owner.global_transform
		transform.origin.x -= initial_x_offset - (i * x_offset_decrement)
		transform.origin.y -= 50
		var fire_range = 210
		var speed = 200
		var spread = 0
		var rotation := 90
		bullet.setup(transform, fire_range, speed, rotation, spread)
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(2.0).timeout
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass

