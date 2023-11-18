extends TileMap

#IF YOU'RE LOOKING TO CREATE TILES SWAP THIS OUT FOR TIMEMAP_MANAGER.GD!

func _ready():
	z_index = SortLayer.FOREGROUND
	

func _deflect(_position) -> void:
	pass
