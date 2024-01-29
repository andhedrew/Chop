extends Marker2D

var entered_water := false
var exited_water := false
var played_unfold_animation := false

func _ready():
	$InWaterTimer.timeout.connect(_timer)
	$AnimationPlayer.play("idle")

func _process(_delta):
	if owner.in_water:
		$InWaterTimer.start()
		exited_water = false
		entered_water = true
		if owner.current_state == "Jump" and played_unfold_animation == true:
			$AnimationPlayer.play("move")
		elif played_unfold_animation:
			$AnimationPlayer.play("idle")
	
		if played_unfold_animation == false:
			$AnimationPlayer.play("unfold")
			await $AnimationPlayer.animation_finished
			played_unfold_animation = true
	
	if not owner.in_water and not exited_water:
		$InWaterTimer.start()
		exited_water = true
	
	
	if owner.facing == Enums.Facing.RIGHT:
		scale.x = -1
		position.x = -6
	elif  owner.facing == Enums.Facing.LEFT:
		scale.x = 1
		position.x = 10


func _timer():
	entered_water = false
	$AnimationPlayer.play("fold")
	await $AnimationPlayer.animation_finished
	played_unfold_animation = false



