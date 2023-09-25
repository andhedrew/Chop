extends Enemy

@export_category("Flyer Properties")
@export_range(0.0, 5.0, 0.5) var erratic_walking_amount := 0.0



func _ready():
	super._ready()
	global_rotation = 0


func _take_damage(hitbox) -> void:
	if hitbox is HitBox and !invulnerable:
		GameEvents.new_vfx.emit("res://vfx/slice_soft.tscn", global_position)
		GameEvents.enemy_took_damage.emit()
		colliding_hitbox_position = {"position": hitbox.owner.get_parent().global_position}
		if death_vocalization:
			SoundPlayer.play_sound_positional(death_vocalization, position)
		GameEvents.drop_food.emit(death_pieces, Vector2(global_position.x, global_position.y - 5))
		die(true)
