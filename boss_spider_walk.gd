extends State

var speed := 40
var attack_timer := randf_range(4.0, 6.0)
var spawn := preload("res://characters/enemy/spider_wall_climb/spider_wall.tscn")
func enter(_msg := {}) -> void:
	attack_timer = randf_range(4.0, 6.0)

func handle_input(_event: InputEvent) -> void:
	pass

func update(delta: float) -> void:
	owner.position.x += speed*delta
	attack_timer -= delta
	if attack_timer < 0:
		spawn_spider()
#		attack(Vector2.ZERO)
		attack_timer = randf_range(4.0, 6.0)

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass


func attack(aim_pos: Vector2):
	var bullet_scene = preload("res://bullets/goo_bullet/goo_bullet.tscn")
	var base_rotation = randf_range(-60, 60)
	var rotation_increment = 90
	var number_of_sets = 8
	var bullets_per_set = 5
	var spread_angle = 65

	for i in range(number_of_sets):
		for j in range(bullets_per_set):
			var bullet = bullet_scene.instantiate()
			owner.add_child(bullet)
			var rotation = base_rotation + spread_angle * (j - 1) # Adjusts for center, left, and right bullets
			var transform = $"../../Marker2D".global_transform
			var fire_range = 300
			var speed = 120
			var spread = 12
			bullet.setup(transform, fire_range, speed, rotation, spread)


func spawn_spider():
	var original_position = $"../../SpawnPoint".global_position
	
	for i in range(3):
		var new_spawn = spawn.instantiate()
		GameEvents.new_vfx.emit("res://vfx/magic_dust_big.tscn", original_position)
		await get_tree().create_timer(0.5).timeout
		get_node("/root/World").add_child(new_spawn)
		new_spawn.z_index = SortLayer.FOREGROUND
		new_spawn.position = original_position
		new_spawn.activate()
		await get_tree().create_timer(0.1).timeout
