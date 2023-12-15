extends TileMap

var animate := false
var retract := false
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.start_octo_battle.connect(_on_start)
	GameEvents.end_octo_battle.connect(_on_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animate:
		position.y = lerp(position.y, 1560.0, 0.2)
	elif retract:
		position.y = lerp(position.y, -1000.0, 0.2)
		


func _on_start():
	animate = true


func _on_end():
	animate = false
	retract = true
