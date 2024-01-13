class_name EnemyWalker
extends Enemy

@export_category("Walker Properties")
@export_range(0.0, 5.0, 0.5) var erratic_walking_amount := 0.0

@onready var ledge_detect_left := $ledge_check_left
@onready var ledge_detect_right := $ledge_check_right


func _ready():
	super._ready()
	if ledge_detect_left or ledge_detect_right:
		ledge_detect_left.force_raycast_update()
		ledge_detect_right.force_raycast_update()

