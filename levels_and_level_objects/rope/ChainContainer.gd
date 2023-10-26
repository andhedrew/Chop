extends Node2D


var chain_link_index := 1

func _ready():
	for i in range(1, get_child_count()):
		var obj := get_child(i)
		if obj is Joint2D:
			var prev_obj := get_child(i-1)
			var next_obj := get_child(i+1)
			obj.node_a = prev_obj.get_path()
			obj.node_b = next_obj.get_path()
		
		if obj is ChainLink:
			var sprite = obj.get_child(0)
			sprite.frame = (chain_link_index%2)
			chain_link_index += 1

