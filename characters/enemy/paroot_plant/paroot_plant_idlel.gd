extends State

@onready var sprite := $"../../Pivot/Body"
var base_time := 3.0
var time = randf_range(base_time - 0.5, base_time + 0.5)
var frame = 0
var time_at_3 = 0
var scene: PackedScene = preload("res://characters/enemy/paroot/paroot.tscn") 

func enter(_msg := {}) -> void:
	pass

func update(delta: float) -> void:
	frame += (delta / time)
	if frame > 3:
		frame = 3
		time_at_3 += delta
		if time_at_3 >= time:
			spawn()
	else:
		time_at_3 = 0
		
	sprite.frame = int(frame)

func spawn() -> void:
	SoundPlayer.play_sound_positional("spit", owner.global_position)
	frame = 0
	var new_spawn = scene.instantiate()
	add_child(new_spawn)
	new_spawn.position = owner.global_position
	new_spawn.velocity = Vector2( 0, -30)
	sprite.frame = frame


func take_damage() -> void:
	if frame > 1 and frame < 2:
		var pickup = preload("res://pickups/food_pickup.tscn").instantiate()
		var sprite := preload("res://characters/enemy/paroot_plant/paroot_plant_drop_1.png")
		pickup.setup(sprite)
		
		add_child(pickup)
		print_debug(str(owner.global_position))
		pickup.position = owner.global_position
		SoundPlayer.play_sound_positional("spit", owner.global_position)
	elif frame > 2:
		if randf() < 0.25:
			var sprite := preload("res://user_interface/healthbar/full_heart.png")
			var pickup := preload("res://pickups/health_pickup.tscn").instantiate()
			pickup.setup(sprite)
			pickup.position = owner.global_position
			get_node("/root/").call_deferred("add_child", pickup)
		
	SoundPlayer.play_sound_positional("bush", owner.global_position)
	frame = 0
