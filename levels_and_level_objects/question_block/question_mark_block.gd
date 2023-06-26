extends Node2D

@onready var hurtbox := $Hurtbox
@export var death_pieces: Array[Resource]
@export var death_pieces2: Array[Resource]

func _ready():
	z_index = SortLayer.BACKGROUND
	hurtbox.area_entered.connect(_take_damage)

func _take_damage(area):
	if area is HitBox:
		if area.execute:
			GameEvents.new_vfx.emit("res://vfx/explosion.tscn", global_position)
			GameEvents.drop_food.emit(death_pieces, global_position)
			var bounty := randf_range(1, 8)
			GameEvents.drop_coins.emit(bounty, global_position)
			queue_free()
