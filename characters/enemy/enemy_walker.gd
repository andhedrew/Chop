class_name EnemyWalker
extends Enemy

@export_category("Walker Properties")
@export_range(0.0, 5.0, 0.5) var erratic_walking_amount := 0.0



func _ready():
	super._ready()

