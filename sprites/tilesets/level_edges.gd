@tool
extends TileMap


func _ready():
	if not Engine.is_editor_hint():
		visible = false
	else:
		z_index = SortLayer.IN_FRONT
