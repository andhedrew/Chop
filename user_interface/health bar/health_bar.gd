extends Control

@export var player: Player
var full_heart = preload("full_heart.png")
var half_heart = preload("half_heart.png")
var empty_heart = preload("empty_heart.png")

func _ready():
	
	GameEvents.player_health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(health, maximum_health):
	var hearts = []
	for i in range(0, maximum_health/2):
		if health >= i * 2 + 2:
			hearts.append(full_heart)
		elif health == i * 2 + 1:
			hearts.append(half_heart)
		else:
			hearts.append(empty_heart)
	for i in range(0, 10):
		var texture_rect = get_node("HBoxContainer/heart_" + str(i))
		texture_rect.visible = false
		
	for i in range(0, maximum_health/2):
		var texture_rect = get_node("HBoxContainer/heart_" + str(i))
		texture_rect.texture = hearts[i]
		texture_rect.visible = true
