extends Control
@export var camera : Camera2D
@export var player: Player
var full_heart = preload("full_heart.png")
var half_heart = preload("half_heart.png")
var empty_heart = preload("empty_heart.png")

# The commented sectons are to be SAVED in case we want to make a killable UI aggain

var bag_contents := []

var current_player_health = 3

func _ready():
	GameEvents.player_health_changed.connect(_on_player_health_changed)
#	hurtbox.position = position
#
#	hurtbox.area_entered.connect(_on_area_entered)

#
#func _process(delta):
#	hurtbox.position = $VBoxContainer.position

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
		var texture_rect = get_node("VBoxContainer/HBoxContainer/heart_" + str(i))
		texture_rect.visible = false
		
	for i in range(0, maximum_health/2):
		var texture_rect = get_node("VBoxContainer/HBoxContainer/heart_" + str(i))
		texture_rect.texture = hearts[i]
		texture_rect.visible = true

#
#func _on_area_entered(area) -> void:
#	if area is HitBox:
#		drop_health_and_die()
#
#
#func die(was_executed: bool = false) -> void:
#	OS.delay_msec(80)
#	var explode := preload("res://vfx/explosion.tscn").instantiate()
#	explode.position = global_position
#	if was_executed:
#		explode.big = true
#	get_node("/root/").add_child(explode)
#	visible = false
#
#func drop_health_and_die() -> void:
#	var explode := preload("res://vfx/blood_explosion.tscn").instantiate()
#	explode.position = global_position
#	explode.restart()
#	explode.emitting = true
#	get_node("/root/").add_child(explode)
#
#	var pos = 30
#	for i in current_player_health*.5:
#		var sprite := preload("res://user_interface/health bar/full_heart.png")
#		var pickup := preload("res://pickups/health_pickup.tscn").instantiate()
#		pickup.setup(sprite)
#		pickup.position = global_position + Vector2((pos*i), 0)
#		get_node("/root/").call_deferred("add_child", pickup)
#
#	die(true)
