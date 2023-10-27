extends Node2D


@export var enemy: PackedScene
@export var wait_time: float = 3

func _ready():
	z_index = SortLayer.IN_FRONT
	$Timer.wait_time = wait_time
	$Timer.timeout.connect(_drop_enemy)


func _drop_enemy() -> void:
	GameEvents.new_vfx.emit("res://vfx/smoke_puff.tscn", global_position)
	await get_tree().create_timer(0.3).timeout
	$AnimationPlayer.play("rattle")
	var new_enemy := enemy.instantiate()
	get_node("/root/World").add_child(new_enemy)
	new_enemy.global_position = global_position
	new_enemy.activate()
	$Timer.start()
