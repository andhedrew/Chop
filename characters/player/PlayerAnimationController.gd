extends Marker2D

@onready var state

var facing = Enums.Facing.RIGHT
@onready var state_last_frame = owner.state
@onready var animation_player := $AnimationPlayer
@onready var effects_player := $EffectsPlayer
var is_landing := false


func _ready():
	pass

func _physics_process(_delta):
	
	if state_last_frame == "Fall" and owner.state != "Fall":
		is_landing = true
	
	match owner.looking:
		Enums.Looking.UP:
			$BulletSpawn.position = Vector2(0, -20)
			match owner.state:
				"Idle": 
					if is_landing: 
						animation_player.play("landing_looking_up") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("idle_looking_up")
					
				"Walk": 
					if is_landing: 
						animation_player.play("landing_looking_up") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("walk_looking_up")
				"Attack": animation_player.play("attack_looking_up")
				"Jump":  animation_player.play("jump_looking_up")
				"Fall":  animation_player.play("fall_looking_up")
				"Execute":  animation_player.play("execute")
				"Cutscene": pass
		_: 
			if Input.is_action_pressed("down") and !owner.is_on_floor():
				$BulletSpawn.position = Vector2(30, 20)
			else: 
				$BulletSpawn.position = Vector2(10, 0)
			match owner.state:
				"Idle": 
					if is_landing: 
						animation_player.play("landing") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("idle")
				"Walk": 
					if is_landing: 
						animation_player.play("landing") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("walk")
				"Attack": animation_player.play("attack")
				"Jump":  animation_player.play("jump")
				"Fall":  animation_player.play("fall")
				"Execute":  animation_player.play("execute")
				"Cutscene": pass
	
	state_last_frame = owner.state


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
