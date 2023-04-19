extends Pickup

var brick_value :int = 0
var meat_value :int = 0
var plant_value :int = 0

var nutrition_value_lookup : Dictionary = {
	load("res://characters/enemy/default/mallow_pieces1.png") : {"brick" : 0, "meat" : 2, "plant" : 0 },
	load("res://characters/enemy/default/mallow_pieces2.png") : {"brick" : 3, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/default/mallow_pieces3.png") : {"brick" : 0, "meat" : 0, "plant" : 4 },
}


func _add_pickup_to_inventory(player) -> void:
	if player.bag_capacity > player.bag.size():
		player.bag.append($Sprite2D.texture)
		GameEvents.added_food_to_bag.emit(self)
		_destroy(player.position)


func setup(new_texture: CompressedTexture2D) -> void:
	$Sprite2D.texture = new_texture
	var size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.extents = size / 2
	
	brick_value = nutrition_value_lookup[new_texture]["brick"]
	meat_value = nutrition_value_lookup[new_texture]["meat"]
	plant_value = nutrition_value_lookup[new_texture]["plant"]
	print_debug("brick" + str(brick_value))
	print_debug("meat" + str(meat_value))
	print_debug("plant" + str(plant_value))
