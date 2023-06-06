class_name ParootBossEnemy
extends Enemy


signal stomped

func _ready():
	super._ready()
	$Pivot/Hurtbox.area_entered.connect(_take_damage)
