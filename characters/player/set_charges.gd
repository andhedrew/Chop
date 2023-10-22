extends Marker2D

var sprites = []
var sprite_width
var cutscene_running := false
var torch_charges_last_frame := 100

func _ready() -> void:
	_on_charge_amount_changed(owner.torch_charges, owner.max_torch_charges)
	GameEvents.charge_amount_changed.connect(_on_charge_amount_changed)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)

func _on_charge_amount_changed(torch_charges, max_torch_charges):
	if not cutscene_running:
		if torch_charges_last_frame < torch_charges:
			SoundPlayer.play_sound("pickup_2")
		visible = true
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
		
		var radius = 30 # Change this value to adjust the radius of the circle.
		var angle_step = 360.0 / max_torch_charges
		
		var center_x = x_offset + total_width / 2.0
		
		for i in range(sprites.size()):
			var sprite = sprites[i]
			
			var angle_degrees = (i * angle_step) - 90.0
			var angle_radians = angle_degrees * PI / 180.0
			
			var x_pos = cos(angle_radians) * radius + center_x
			var y_pos = sin(angle_radians) * radius
			
			sprite.position = Vector2(x_pos, y_pos)
			
			add_child(sprite)
		
		torch_charges_last_frame = torch_charges


func _on_cutscene_start() -> void:
	cutscene_running = true


func _on_cutscene_end() -> void:
	cutscene_running = false

