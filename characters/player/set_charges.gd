#extends Marker2D
#var sprites = []
#
#func _ready() -> void:
#	_on_charge_amount_changed(owner.torch_charges, owner.max_torch_charges)
#	GameEvents.charge_amount_changed.connect(_on_charge_amount_changed)
#
#
#func _on_charge_amount_changed(torch_charges, max_torch_charges):
#	# Remove any existing sprites
#	for sprite in sprites:
#		sprite.queue_free()
#	sprites.clear()
#
#	# Create new sprites
#	for i in range(max_torch_charges):
#		var sprite = Sprite2D.new()
#		if i < torch_charges:
#			sprite.frame = 0
#		else:
#			sprite.frame = 1
#
#		sprite.texture = preload("res://user_interface/torch_charges/charge.png")
#		sprite.hframes = 2
#		sprite.position = Vector2(i * sprite.texture.get_width(), 0)
#		add_child(sprite)
#		sprites.append(sprite)


extends Marker2D

var sprites = []
var sprite_width

func _ready() -> void:
	_on_charge_amount_changed(owner.torch_charges, owner.max_torch_charges)
	GameEvents.charge_amount_changed.connect(_on_charge_amount_changed)


func _on_charge_amount_changed(torch_charges, max_torch_charges):
	# Remove any existing sprites
	for sprite in sprites:
		sprite.queue_free()
	sprites.clear()

	# Create new sprites
	var total_width = 0
	for i in range(max_torch_charges):
		var sprite = Sprite2D.new()
	
		sprite.texture = preload("res://user_interface/torch_charges/charge.png")
		sprite.hframes = 2
		if i < torch_charges:
			sprite.frame = 0
		else:
			sprite.frame = 1
		total_width += sprite.texture.get_width()
		sprites.append(sprite)
		sprite_width = sprite.texture.get_width()

	# Center the sprites horizontally
	var x_offset = (sprite_width - total_width) / 2 +4
	for i in range(sprites.size()):
		var sprite = sprites[i]
		sprite.position = Vector2(i * sprite.texture.get_width() + x_offset, 0)
		
		add_child(sprite)
