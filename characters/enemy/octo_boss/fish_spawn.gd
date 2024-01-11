
extends Marker2D

@export var spawn: PackedScene = preload("res://characters/enemy/fish_jumper/fish_jumper.tscn")
@export var pool_size := 20
var pool := []
# Array to keep track of spawned fish
var fish_instances = []

func _ready():
	GameEvents.spawn_fish.connect(spawn_fish)
	_initialize_pool()


func _initialize_pool():
	for i in range(pool_size):
		var enemy_instance = spawn.instantiate()
		enemy_instance.visible = false
		enemy_instance.set_process(false)  # Disable processing"res://pickups/coin_pickup_float.tscn"
		enemy_instance.set_physics_process(false)  # Disable physics processing
		enemy_instance.set("is_pooled", true)
		enemy_instance.set("active", false)
		enemy_instance.set("pool_pos", global_position)
		enemy_instance.pool = self
		enemy_instance.in_a_pool = true
		enemy_instance.z_index = SortLayer.PLAYER
		enemy_instance.reset()
#		for hitbox in enemy_instance.get_children():
#			if hitbox is CollisionShape2D or hitbox is Area2D:
#				hitbox.set_deferred("disabled", true)
		get_node("/root/World").call_deferred("add_child", enemy_instance)
		enemy_instance.position = Vector2.ZERO
		pool.append(enemy_instance)


func _process(delta):
	check_fish_status()
	if Input.is_action_just_pressed("1"):
		spawn_fish()

func spawn_fish():
	var original_position = global_position # Store the original position
	var rect_width = 300
	var rect_height = 150

	fish_instances.clear() # Clear the array when spawning new fish
	for i in range(3):
		# Set a random position within the rectangle
		global_position = original_position + Vector2(randf_range(-rect_width / 2, rect_width / 2), randf_range(-rect_height / 2, rect_height / 2))

		var new_spawn = _get_pooled_enemy()
		if new_spawn != null:

#			GameEvents.new_vfx.emit("res://vfx/magic_dust_big.tscn", global_position)
#			await get_tree().create_timer(0.5).timeout
			new_spawn.visible = true
			new_spawn.z_index = SortLayer.FOREGROUND
			new_spawn.global_position = global_position
			fish_instances.append(new_spawn)

		# Wait a bit before spawning the next fish
#		await get_tree().create_timer(0.1).timeout
		new_spawn.set_facing(new_spawn.facing)

	global_position = original_position # Reset position to original after spawning fish

func check_fish_status():
	# Filter the fish_instances array to keep only valid instances
	var valid_fish = []
	for fish in fish_instances:
		if is_instance_valid(fish):
			valid_fish.append(fish)

	fish_instances = valid_fish

	# Check if all fish are destroyed
	if len(fish_instances) == 0:
		GameEvents.fish_dead.emit()


func _get_pooled_enemy() -> Node:

	for e in pool:
		if e.get("is_pooled"):
			e.set("is_pooled", false)
			e.set("active", true)
			e.visible = true
			e.set_process(true)  # Re-enable processing
			e.set_physics_process(true)  # Re-enable physics processing
			e.reset()
			return e
	return null




func return_to_pool(enemy_node: Node):
	if is_instance_valid(enemy_node):
		enemy_node.set("is_pooled", true)
		enemy_node.set("active", false)
		enemy_node.visible = false
		enemy_node.set_process(false)
		enemy_node.set_physics_process(false)
	else:
		# Handle the case where the instance is not valid
		print("Attempted to return an invalid enemy to the pool.")
		pool.erase(enemy_node)  # Remove invalid instance from the pool
