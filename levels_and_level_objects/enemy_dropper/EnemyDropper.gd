class_name Dropper
extends Node2D

@export var enemy: PackedScene
@export var wait_time: float = 3
@export var pool_size := 5
var pool := []

func _ready():
	z_index = SortLayer.IN_FRONT
	$Timer.wait_time = wait_time
	$Timer.timeout.connect(_drop_enemy)
	_initialize_pool()
	print("Starting Timer")
	$Timer.start()  # Start the timer initially

func _initialize_pool():
	for i in range(pool_size):
		var enemy_instance = enemy.instantiate()
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
		for hitbox in enemy_instance.get_children():
			if hitbox is CollisionShape2D or hitbox is Area2D:
				hitbox.set_deferred("disabled", true)
		get_node("/root/World").call_deferred("add_child", enemy_instance)
		enemy_instance.position = global_position
		pool.append(enemy_instance)

func _get_pooled_enemy() -> Node:
	for e in pool:
		if e.get("is_pooled"):
			e.set("is_pooled", false)
			e.set("active", true)
			e.visible = true
			e.set_process(true)  # Re-enable processing
			e.set_physics_process(true)  # Re-enable physics processing
			e.reset()
			for hitbox in e.get_children():
				if hitbox is CollisionShape2D or hitbox is Area2D:
					hitbox.set_deferred("disabled", false)
			return e

	# If no pooled enemy is available, create a new one (optional)
	var new_enemy = enemy.instantiate()
	new_enemy.set("is_pooled", false)
	new_enemy.set("active", true)
	get_node("/root/World").add_child(new_enemy)
	return new_enemy

func _drop_enemy() -> void:
	GameEvents.new_vfx.emit("res://vfx/smoke_puff.tscn", global_position)
	await get_tree().create_timer(0.3).timeout
	$AnimationPlayer.play("rattle")
	var pooled_enemy = _get_pooled_enemy()
	if pooled_enemy != null:
		pooled_enemy.global_position = global_position
		pooled_enemy.visible = true


func return_to_pool(enemy_node: Node):
	if is_instance_valid(enemy_node):
		enemy_node.set("is_pooled", true)
		enemy_node.set("active", false)
		enemy_node.visible = false
		enemy_node.set_process(false)
		enemy_node.set_physics_process(false)
		# Reset any other state of the enemy as necessary
		# Deactivate all hitboxes
		for hitbox in enemy_node.get_children():
			if hitbox is CollisionShape2D or hitbox is Area2D:
				hitbox.set_deferred("disabled", true)
	else:
		# Handle the case where the instance is not valid
		print("Attempted to return an invalid enemy to the pool.")
		pool.erase(enemy_node)  # Remove invalid instance from the pool


#extends Node2D
#
#@export var enemy: PackedScene
#@export var wait_time: float = 3
#@export var pool_size := 5
#var pool := []
#
#func _ready():
#	z_index = SortLayer.FOREGROUND
#	$Timer.wait_time = wait_time
#	$Timer.timeout.connect(_drop_enemy)
#	_initialize_pool()
#	print("Starting Timer")
#	$Timer.start()  # Start the timer initially
#
#func _initialize_pool():
#	for i in range(pool_size):
#		var enemy_instance = enemy.instantiate()
#		enemy_instance.visible = false  # Initially hidden
#		enemy_instance.set("is_pooled", true)  # Custom property
#		enemy_instance.set("in_a_pool", true)
#		enemy_instance.set("active", false)  # Custom property
#		enemy_instance.set("pool_pos", global_position)
#
#		get_node("/root/World").call_deferred("add_child", enemy_instance)
#		enemy_instance.position = global_position
#		pool.append(enemy_instance)
#
#func _get_pooled_enemy() -> Node:
#	for e in pool:
#		if e.get("is_pooled"):
#			e.set("is_pooled", false)
#			e.set("active", true)
#			return e
#
#	# If no pooled enemy is available, create a new one (optional)
#	var new_enemy = enemy.instantiate()
#	new_enemy.set("is_pooled", false)
#	new_enemy.set("active", true)
#	get_node("/root/World").add_child(new_enemy)
#	return new_enemy
#
#func _drop_enemy() -> void:
#	GameEvents.new_vfx.emit("res://vfx/smoke_puff.tscn", global_position)
#	await get_tree().create_timer(0.3).timeout
#	$AnimationPlayer.play("rattle")
#	var pooled_enemy = _get_pooled_enemy()
#	if pooled_enemy != null:
#		pooled_enemy.global_position = global_position
#		pooled_enemy.visible = true
#	else:
#		print("No pooled enemy available")
#
#
#func return_to_pool(enemy_node: Node):
#	enemy_node.set("is_pooled", true)
#	enemy_node.set("active", false)
#	enemy_node.visible = false
#	# Reset any other state of the enemy as necessary
