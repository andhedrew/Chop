extends Pickup




var brick_value :int = 0
var meat_value :int = 0
var plant_value :int = 0
var feeding := false
@onready var current_texture = $Sprite2D.texture
var nutrition_value_lookup : Dictionary = {
	load("res://characters/enemy/default/mallow_pieces1.png") : {"brick" : 20, "meat" : 22, "plant" : 20 },
	load("res://characters/enemy/default/mallow_pieces2.png") : {"brick" : 23, "meat" : 20, "plant" : 20 },
	load("res://characters/enemy/default/mallow_pieces3.png") : {"brick" : 20, "meat" : 20, "plant" : 24 },
	load("res://characters/enemy/dandicrow/dandicrow_piece1.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	load("res://characters/enemy/hotdog/HotDog1.png") : {"brick" : 0, "meat" : 2, "plant" : 0 },
	load("res://characters/enemy/hotdog/HotDog2.png") : {"brick" : 0, "meat" : 2, "plant" : 0 },
	load("res://characters/enemy/paroot/paroot_drop_1.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	load("res://characters/enemy/paroot/paroot_drop_2.png") : {"brick" : 0, "meat" : 1, "plant" : 1 },
	load("res://characters/enemy/paroot/paroot_drop_3.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	load("res://characters/enemy/pumpiboo/pumpiboo_drop_1.png") : {"brick" : 0, "meat" : 0, "plant" : 2 },
	load("res://characters/enemy/pumpiboo/pumpiboo_drop_2.png") : {"brick" : 0, "meat" : 0, "plant" : 2 },
	
	load("res://characters/enemy/eggplant/egg_plant_drop_1.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	load("res://characters/enemy/eggplant/egg_plant_drop_2.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	
	load("res://characters/player/death_pieces/player_death_pieces_1.png") : {"brick" : 0, "meat" : 1000000, "plant" : 0 },
	load("res://characters/player/death_pieces/player_death_pieces_2.png") : {"brick" : 0, "meat" : 1000000, "plant" : 0 },
	load("res://characters/player/death_pieces/player_death_pieces_3.png") : {"brick" : 0, "meat" : 1000000, "plant" : 0 },
	
	load("res://pickups/sprites/brick.png") : {"brick" : 100, "meat" : 0, "plant" : 0 },
	
	load("res://user_interface/healthbar/full_heart.png") : {"brick" : 0, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/moss_hopper/moss_hopper_piece.png") : {"brick" : 0, "meat" : 0, "plant" : 1 },
	load("res://characters/enemy/paroot/pareet_drop.png") : {"brick" : 0, "meat" : 1, "plant" : 1 },
	load("res://characters/enemy/paroot_boss/paroot_boss_deathpiece_1.png") : {"brick" : 10, "meat" : 1, "plant" : 3 },
	load("res://characters/enemy/paroot_boss/paroot_boss_deathpiece_2.png") : {"brick" : 8, "meat" : 1, "plant" : 2 },
	load("res://characters/enemy/paroot_boss/paroot_boss_deathpiece_4.png") : {"brick" : 3, "meat" : 1, "plant" : 1 },
	load("res://characters/enemy/paroot_boss/paroot_boss_deathpiece_4.png") : {"brick" : 1, "meat" : 1, "plant" : 1 },
	load("res://characters/enemy/paroot_boss/paroot_boss_deathpiece_5.png") : {"brick" : 0, "meat" : 20, "plant" : 10 },
	load("res://levels_and_level_objects/question_block/question_block_pieces_1.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	load("res://levels_and_level_objects/question_block/question_block_pieces_2.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	
	load("res://characters/enemy/fish_jumper/fish_jumper_pieces_1.png") : {"brick" : 0, "meat" : 5, "plant" : 0 },
	load("res://characters/enemy/fish_jumper/fish_jumper_pieces_2.png") : {"brick" : 0, "meat" : 1, "plant" : 0 },
	
	load("res://characters/enemy/grabnimonie/grabnimonie_pieces_1.png") : {"brick" : 0, "meat" : 0, "plant" : 3 },
	load("res://characters/enemy/grabnimonie/grabnimonie_pieces_2.png") : {"brick" : 0, "meat" : 0, "plant" : 2 },
	load("res://characters/enemy/grabnimonie/grabnimonie_pieces_3.png") : {"brick" : 0, "meat" : 0, "plant" : 2 },
	
	load("res://characters/enemy/jelly/jelly_pieces.png") : {"brick" : 4, "meat" : 1, "plant" : 0 },
	
	load("res://characters/enemy/sea_slug/sea_slug_pieces_1.png") : {"brick" : 1, "meat" : 1, "plant" : 0 },
	load("res://characters/enemy/sea_slug/sea_slug_pieces_2.png") : {"brick" : 1, "meat" : 1, "plant" : 0 },
	
	load("res://characters/enemy/starforsh/starforsh_pieces_1.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/starforsh/starforsh_pieces_2.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/starforsh/starforsh_pieces_3.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/starforsh/starforsh_pieces_4.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	load("res://characters/enemy/starforsh/starforsh_pieces_5.png") : {"brick" : 1, "meat" : 0, "plant" : 0 },
	
	load("res://characters/enemy/yellow_fish/yeller_fish_pieces1.png") : {"brick" : 0, "meat" : 2, "plant" : 0 },
	load("res://characters/enemy/yellow_fish/yeller_fish_pieces2.png") : {"brick" : 0, "meat" : 2, "plant" : 0 },
	
	
}

func _ready():
	super()
	if nutrition_value_lookup.has(current_texture):
		brick_value = nutrition_value_lookup[current_texture]["brick"]
		meat_value = nutrition_value_lookup[current_texture]["meat"]
		plant_value = nutrition_value_lookup[current_texture]["plant"]
	else:
		brick_value = 1
		meat_value = 0
		plant_value = 0
	z_index = SortLayer.FOREGROUND
	
	
	
func _physics_process(delta):
	super(delta)
	if feeding:
		scale -= Vector2(delta, delta)
		$CollisionShape2D.disabled = true

func _add_pickup_to_inventory(player) -> void:
	if player.bag_capacity > player.bag.size():
		player.bag.append($Sprite2D.texture.resource_path)
		SaveManager.save_item("bag", player.bag)
		GameEvents.added_food_to_bag.emit(self)
		_destroy(player.position)
	else:
		GameEvents.bag_full.emit()


func setup(new_texture: CompressedTexture2D, setup_collision : bool = true) -> void:
	$Sprite2D.texture = new_texture
	if setup_collision:
		var size = $Sprite2D.texture.get_size()
		$CollisionShape2D.shape = RectangleShape2D.new()
		$CollisionShape2D.shape.extents = (size * 0.8) / 2
	
	if nutrition_value_lookup.has(new_texture):
		brick_value = nutrition_value_lookup[new_texture]["brick"]
		meat_value = nutrition_value_lookup[new_texture]["meat"]
		plant_value = nutrition_value_lookup[new_texture]["plant"]
	else:
		brick_value = 1
		meat_value = 0
		plant_value = 0

