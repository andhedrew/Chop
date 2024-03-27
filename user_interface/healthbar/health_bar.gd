extends Control
@export var camera : Camera2D
@export var player: Player
var full_heart = preload("full_heart.png")
var half_heart = preload("half_heart.png")
var empty_heart = preload("empty_heart.png")
@onready var animation_player := $AnimationPlayer
# The commented sectons are to be SAVED in case we want to make a killable UI aggain
var bag_contents := []
var current_player_health = 3

func _ready():
	current_player_health = SaveManager.load_item("health")
	_on_player_health_changed(current_player_health, current_player_health)
	GameEvents.cutscene_started.connect(_on_cutscene_started)
	GameEvents.cutscene_ended.connect(_on_cutscene_ended)
	GameEvents.player_health_changed.connect(_on_player_health_changed)


func _on_player_health_changed(health, maximum_health):
	var hearts = []
	current_player_health = health
	for i in range(0, maximum_health/2):
		if health >= i * 2 + 2:
			hearts.append(full_heart)
		elif health == i * 2 + 1:
			hearts.append(half_heart)
		else:
			hearts.append(empty_heart)
	for i in range(0, 10):
		var texture_rect = get_node(
			"VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/heart_" + str(i))
		texture_rect.visible = false
		
	for i in range(0, maximum_health/2):
		var texture_rect = get_node(
			"VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/heart_" + str(i))
		texture_rect.texture = hearts[i]
		texture_rect.visible = true

func _on_cutscene_started() -> void:
	if not $VBoxContainer.modulate.a == 0:
		animation_player.play("fade_out")


func _on_cutscene_ended() -> void:
	if $VBoxContainer.modulate.a <= 0.1:
		animation_player.play("fade_in")

