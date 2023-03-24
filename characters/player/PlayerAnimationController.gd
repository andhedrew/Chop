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
				"Cutscene": animation_player.play("watch")
	
	state_last_frame = owner.state


func _set_facing(player_facing_direction) -> void:
	facing = player_facing_direction


func _damage_effects(damage_amount):
	if damage_amount < 0:
		effects_player.play("take_damage")
	else:
		effects_player.play("heal")
