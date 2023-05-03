extends Pickup

@export var value : int = 1
@onready var sprite := $Sprite2D

func _ready():
	z_index = sort_layer
	animation_player.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)
	$SlowPickupTimer.start()
	match value:
		1: sprite.texture = preload("res://user_interface/coin1.png")
		2: sprite.texture = preload("res://user_interface/coin2.png")
		4: sprite.texture = preload("res://user_interface/coin3.png")
		8: sprite.texture = preload("res://user_interface/coin4.png")

func _add_pickup_to_inventory(player) -> void:
	player.money += value
	SaveManager.save_item("money", player.money)
	GameEvents.player_money_changed.emit(player.money)
	_destroy(player.position)
		
