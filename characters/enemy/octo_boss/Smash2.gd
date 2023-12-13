extends State

var speed = 200 # Speed of the object
var direction = Vector2(0, 1) # Initial direction
var start_position # To store the start position
var go_home := false
var wait := false

func enter(msg := {}) -> void:
	start_position = owner.global_position
	$"../../Phase2SmashHitbox".set_deferred("monitorable", true)
	direction = direction.normalized() # Ensure the direction is normalized
	speed = 200


func physics_update(delta: float) -> void:
	
	var collision_info = owner.move_and_collide(direction * speed * delta)

	if collision_info:
		# Reflect the direction if there's a collision
		direction = _pick_new_dir(direction)

#	# Optional: Check if the object is back to its original position
	if go_home:
		if owner.global_position.x-1 <= start_position.x:
			direction = Vector2(0, 0)
			wait = true
			await get_tree().create_timer(1.0).timeout
			speed = 80
			wait = false
			direction = Vector2(0, -1)
		if owner.global_position.distance_to(start_position) < 3: # 10 is a threshold
			owner.global_position = start_position # Reset position
			go_home = false
			direction = Vector2(0, 1)
			state_machine.transition_to("Idle")

func exit() -> void:
	$"../../Phase2SmashHitbox".set_deferred("monitorable", false)


func _pick_new_dir(dir) -> Vector2:
	GameEvents.boss_hit_wall.emit()
	if dir == Vector2(0, 1):
		return Vector2(-1, -0.1)
	elif dir == Vector2(-1, -0.1):
		return Vector2(1, -0.1)
	else:
		go_home = true
		return Vector2(-1, 0)
