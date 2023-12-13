extends State

var bullet_marker: Marker2D
var rot := 0
var hurtbox
var spawn_pos: Vector2
var spawn_transform: Transform2D
func enter(msg := {}) -> void:
	await get_tree().create_timer(0.3).timeout
	match msg["arm"]:
		"left":
			$"../../AnimationPlayer".play("smash_arm_left")
			bullet_marker = $"../../ArmFrontLeft/SmashMarkerLeft"
			rot = 180
			hurtbox = $"../../ArmFrontLeft/Hurtbox"
			spawn_pos = bullet_marker.global_position
			spawn_transform =  bullet_marker.global_transform
			
		"right":
			$"../../AnimationPlayer".play("smash_arm_right")
			bullet_marker = $"../../ArmFrontRight/SmashMarkerRight"
			rot = 0
			hurtbox = $"../../ArmFrontRight/Hurtbox"
			spawn_pos = bullet_marker.global_position
			spawn_transform =  bullet_marker.global_transform

	
	
	
func _spawn_bullet():
	
	GameEvents.boss_hit_wall.emit()
	GameEvents.new_vfx.emit("res://vfx/dirt_explode.tscn", spawn_pos)
	var bullet = preload("res://bullets/vine_whip_bullet/vine_whip_bullet_big.tscn").instantiate()
	owner.add_child(bullet)
	var transform = spawn_transform
	var fire_range = 200
	var speed = 250
	var spread = 0
	var rotation := rot
	bullet.setup(transform, fire_range, speed, rotation, spread)
	
	bullet = preload("res://bullets/vine_whip_bullet/vine_whip_bullet_big.tscn").instantiate()
	owner.add_child(bullet)
	rotation = rot - 180
	bullet.setup(transform, fire_range, speed, rotation, spread)
	
	
		
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass

func activate_hurtbox():
	hurtbox.set_deferred("monitoring", true)

func deactivate_hurtboxes():
	if not owner.arm_gone["left"]:
		$"../../ArmFrontLeft/Hurtbox".set_deferred("monitoring", false)
	if not owner.arm_gone["right"]:
		$"../../ArmFrontRight/Hurtbox".set_deferred("monitoring", false)

