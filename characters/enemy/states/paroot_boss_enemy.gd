class_name ParootBossEnemy
extends Enemy


signal stomped
var count := 0

func _ready():
	super._ready()
	$Pivot/Hurtbox.area_entered.connect(_take_damage)


func _process(delta):
	count += 1
	if invulnerable:
		print_debug("invulnerable" + str(count))
		effects_player.play("invulnerable")


func _take_damage(hitbox) -> void:
	if hitbox is HitBox and !invulnerable:
		GameEvents.enemy_took_damage.emit()
		colliding_hitbox_position = {"position": hitbox.owner.get_parent().global_position}
		$StateMachine.transition_to("Hurt", colliding_hitbox_position)
		health -= hitbox.damage
		if health <= 0:
			$StateMachine.transition_to("Die")
		else:
			var slice = preload("res://vfx/slice.tscn").instantiate()
			slice.position = global_position
			get_node("/root/World").add_child(slice)
