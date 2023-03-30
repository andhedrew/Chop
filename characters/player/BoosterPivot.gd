extends Marker2D
var sound_player: AudioStreamPlayer
var started_engine_sound := false

func _ready():
	$AnimationPlayer.play("booster")
	visible = false
	

func _process(_delta):
	if $"../StateMachine".state.name == "Dash":
		visible = true
		$arrow.visible = true
		if owner.torch_charges <= 0:
			var smoke = preload("res://vfx/smoke.tscn").instantiate()
			get_node("/root/").add_child(smoke)
			smoke.position = global_position
			smoke.z_index = SortLayer.FOREGROUND
			smoke.restart()
			smoke.emitting = true
			
	elif $"../StateMachine".state.name == "Idle" or $"../StateMachine".state.name == "Walk":
		$arrow.visible = false
	else:
		$arrow.visible = false

	
	
	var direction = Vector2(Input.get_axis("right", "left"), Input.get_axis("down", "up")).normalized()
	if direction != Vector2.ZERO:
		rotation = direction.angle()  + deg_to_rad(90)
	if owner.facing == Enums.Facing.RIGHT:
		scale.x = -1
		position.x = -6
	elif  owner.facing == Enums.Facing.LEFT:
		scale.x = 1
		position.x = 6

