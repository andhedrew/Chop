extends Marker2D
var sound_player: AudioStreamPlayer
var started_engine_sound := false
var started_stalling_sound := false

var spawn_played := false

func _ready():
	visible = false
	$"../Charges".visible = false
	

func _process(_delta):
	if owner.has_booster_upgrade:
		visible = true
		if not spawn_played:
			$AnimationPlayer.play("booster_spawn")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("booster")
			$"../Charges".visible = true
			spawn_played = true
		
		

	if $"../StateMachine".state.name == "Dash":
		if owner.torch_charges > 0:
			if !started_engine_sound:
				sound_player = SoundPlayer.play_sound("engine")
				started_engine_sound = true
		elif !started_stalling_sound:
			started_stalling_sound = true
			if sound_player:
				sound_player.queue_free()
				sound_player = null
			SoundPlayer.play_sound("engine_die")
			
		
		$arrow.visible = true
		if owner.torch_charges <= 0:
			
			var smoke = preload("res://vfx/smoke.tscn").instantiate()
			get_node("/root/World").add_child(smoke)
			smoke.position = global_position
			smoke.z_index = SortLayer.FOREGROUND
			smoke.restart()
			smoke.emitting = true
			
	elif $"../StateMachine".state.name == "Idle" or $"../StateMachine".state.name == "Move" or $"../StateMachine".state.name == "Cutscene":
		
		started_engine_sound = false
		started_stalling_sound = false
		if sound_player:
			sound_player.queue_free()
			sound_player = null
	else:
		$arrow.visible = false
		started_stalling_sound = false

	var direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()
	if direction != Vector2.ZERO:
		rotation = direction.angle()  + deg_to_rad(90)
	if owner.facing == Enums.Facing.RIGHT:
		scale.x = -1
		position.x = -6
	elif  owner.facing == Enums.Facing.LEFT:
		scale.x = 1
		position.x = 6

