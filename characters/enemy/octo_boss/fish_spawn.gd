extends Marker2D

@export var spawn: PackedScene = preload("res://characters/enemy/fish_jumper/fish_jumper.tscn")

# Array to keep track of spawned fish
var fish_instances = []

func _ready():
	GameEvents.spawn_fish.connect(spawn_fish)

func _process(delta):
	check_fish_status()

func spawn_fish():
	var original_position = global_position # Store the original position
	var rect_width = 300
	var rect_height = 150

	fish_instances.clear() # Clear the array when spawning new fish
	for i in range(3):
		# Set a random position within the rectangle
		global_position = original_position + Vector2(randf_range(-rect_width / 2, rect_width / 2), randf_range(-rect_height / 2, rect_height / 2))

		var new_spawn = spawn.instantiate()
		GameEvents.new_vfx.emit("res://vfx/magic_dust_big.tscn", global_position)
		await get_tree().create_timer(0.5).timeout
		get_parent().add_child(new_spawn)
		new_spawn.z_index = SortLayer.FOREGROUND
		new_spawn.position = global_position
		fish_instances.append(new_spawn)

		# Wait a bit before spawning the next fish
		await get_tree().create_timer(0.1).timeout
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
