extends Marker2D

@onready var state

var facing = Enums.Facing.RIGHT

@onready var animation_player := $AnimationPlayer
@onready var effects_player := $EffectsPlayer

var landing := false
var played_death_animation := false
var died_in_the_air := false
var play_alt_slash_attack := false
var double_jump_available := false

func _ready():
	GameEvents.player_changed_facing.connect(_set_facing)
	GameEvents.player_changed_state.connect(_set_state)
	GameEvents.player_health_changed.connect(_damage_effects)
	GameEvents.double_jump_refreshed.connect(_double_jump_refreshed_effects)



func _physics_process(_delta):
	if not landing and not died_in_the_air:
		if state == "Idle":
			if facing == Enums.Facing.UP:animation_player.play("idle_looking_up")
			else:animation_player.play("idle")
		elif state == "Walk":
			if facing == Enums.Facing.UP:animation_player.play("walk_looking_up")
			else:animation_player.play("walk")
		elif state == "Jump":
#			$DoubleJumpCloud.emitting = false
			if facing == Enums.Facing.UP:animation_player.play("jump_looking_up")
			else:animation_player.play("jump")
		elif state == "Fall":
			if facing == Enums.Facing.UP:animation_player.play("fall_looking_up")
			else:animation_player.play("fall")
		elif state == "Attack":
			if facing == Enums.Facing.UP and !play_alt_slash_attack:
				animation_player.play("attack_looking_up")
			elif facing == Enums.Facing.UP and play_alt_slash_attack:
				animation_player.play("alt_attack_looking_up")
			elif play_alt_slash_attack: 
				animation_player.play("attack") 
			else: 
				animation_player.play("alt_slash_attack") 
		elif state == "Execute":
			animation_player.play("execute")
		elif state == "Cutscene":
			animation_player.play("watch")


func _set_state(next_state):
	if state == "Fall" and (next_state == "Idle" or next_state == "Walk"): 
		if facing == Enums.Facing.UP:animation_player.play("landing_looking_up")
		else:animation_player.play("landing")
		landing = true
#		var landing_dust = preload("res://vfx/puff_of_dust.tscn").instantiate()
#		landing_dust.position = global_position
#		landing_dust.emitting = true
#		get_tree().get_root().add_child(landing_dust)
#		$DoubleJumpCloud.emitting = false
	state = next_state


func _set_facing(player_facing_direction) -> void:
	facing = player_facing_direction
#	if owner.is_on_floor():
#		var landing_dust = preload("res://vfx/puff_of_dust.tscn").instantiate()
#		landing_dust.position = global_position
#		if player_facing_direction == Enums.Facing.RIGHT:
#			landing_dust.position.x -= 16
#		elif player_facing_direction == Enums.Facing.LEFT:
#			landing_dust.position.x += 16
#		landing_dust.amount = 3
#		landing_dust.emitting = true
#		get_tree().get_root().add_child(landing_dust)


func _damage_effects(damage_amount):
	if damage_amount < 0:
		effects_player.play("take_damage")
	else:
		effects_player.play("heal")



func _double_jump_refreshed_effects() -> void:
	double_jump_available = true
	effects_player.play("refresh_jump")
#	$DoubleJumpCloud.emitting = true

func _finished_landing() -> void:
	landing = false
