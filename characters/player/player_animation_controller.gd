extends Marker2D

@onready var state

var facing = Enums.Facing.RIGHT
@onready var state_last_frame = owner.state
@onready var animation_player := $AnimationPlayer
@onready var effects_player := $EffectsPlayer
var is_landing := false
var feeding := false

func _ready():
	GameEvents.started_feeding_little_brother.connect(_on_feeding_brother)
	GameEvents.done_feeding_little_brother.connect(_on_cutscene_end)
	GameEvents.evening_started.connect(_on_end_of_day)
	GameEvents.morning_started.connect(_on_start_of_day)

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
					
				"Move": 
					if is_landing: 
						animation_player.play("landing_looking_up") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("walk_looking_up")
				"Attack": animation_player.play("attack_looking_up")
				"Jump":  animation_player.play("jump_looking_up")
				"Fall":  animation_player.play("fall_looking_up")
				"Execute":  animation_player.play("execute")
				"Cutscene": 
					if feeding:
						if !owner.is_on_floor():
							animation_player.play("fall_looking_up")
						else: 
							animation_player.play("watch")
		_: 

			match owner.state:
				"Idle": 
					if is_landing: 
						animation_player.play("landing") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("idle")
				"Move": 
					if is_landing: 
						animation_player.play("landing") 
						await animation_player.animation_finished
						is_landing = false
					else: animation_player.play("walk")
				"Attack": animation_player.play("attack")
				"Syphon": animation_player.play("syphon")
				"Jump":  animation_player.play("jump")
				"Fall":  animation_player.play("fall")
				"Execute":  animation_player.play("execute")
				"Cutscene": 
					if feeding:
						if !owner.is_on_floor():
							animation_player.play("fall_looking_up")
						else: 
							animation_player.play("watch")
	
	state_last_frame = owner.state


func _set_facing(player_facing_direction) -> void:
	facing = player_facing_direction


func _damage_effects(damage_amount):
	if damage_amount < 0:
		effects_player.play("take_damage")
	else:
		effects_player.play("heal")


func _on_end_of_day() -> void:
	
	facing = Enums.Facing.LEFT
	animation_player.play("stick_cleaver_in_ground")
	SoundPlayer.play_sound("swoosh")
	SoundPlayer.play_sound("stab1")
	await animation_player.animation_finished
	SoundPlayer.play_music("lull")
	animation_player.play("sit_on_cleaver")
	await animation_player.animation_finished
	await get_tree().create_timer(0.5).timeout
	animation_player.play("sing")
	await get_tree().create_timer(10.0).timeout
	
	animation_player.play("sleep")
	await get_tree().create_timer(3.0).timeout
	GameEvents.evening_ended.emit()


func _on_start_of_day() -> void:
	animation_player.play("wake_up")
	await animation_player.animation_finished
	animation_player.play_backwards("sit_on_cleaver")
	await animation_player.animation_finished


func _on_feeding_brother() -> void:
	feeding = true


func _on_cutscene_end() -> void:
	feeding = false
