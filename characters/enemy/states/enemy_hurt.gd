class_name EnemyHurt
extends State

var hitbox_position : Vector2

func enter(msg := {}) -> void:
	if owner.hurt_vocalizations.size() > 0:
		var random_index = randi() % owner.hurt_vocalizations.size()
		var random_value = owner.hurt_vocalizations[random_index]
		SoundPlayer.play_sound_positional(random_value, owner.global_position)
	
	owner.animation_player.play("hurt")
	owner.effects_player.play("take_damage")
	

func update(_delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
	
func exit() -> void:
	pass
