extends StaticBody2D

@onready var hurtbox := $Hurtbox
@export var death_pieces: Array[Resource]
@export var death_pieces2: Array[Resource]
@export var GOLD := false

func _ready():
	z_index = SortLayer.PLAYER
	hurtbox.area_entered.connect(_take_damage)

func _take_damage(area):
	if area is HitBox:
		if area.execute:
			if GOLD:
				GameEvents.new_vfx.emit("res://vfx/explosion.tscn", global_position)
				GameEvents.drop_food.emit(death_pieces, global_position)
				var amnt = 8
				GameEvents.drop_coins.emit(amnt, global_position)
				SoundPlayer.play_sound("ping")
				SoundPlayer.play_sound("buy")
				queue_free()
			elif randf() > 0.5:
				GameEvents.new_vfx.emit("res://vfx/explosion.tscn", global_position)
				GameEvents.drop_food.emit(death_pieces, global_position)
				var weighted_array = [1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 4, 5, 6, 7, 8]
				var random_index = randi() % weighted_array.size()
				var random_value = weighted_array[random_index]
				GameEvents.drop_coins.emit(random_value, global_position)
				queue_free()
			else:
				GameEvents.new_vfx.emit("res://vfx/explosion.tscn", global_position)
				GameEvents.drop_food.emit(death_pieces, global_position)
				GameEvents.drop_health.emit(global_position)
				queue_free()
