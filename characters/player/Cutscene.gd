extends State

var end_of_level := false


func _ready():
	GameEvents.continue_day.connect(_on_end_of_day)
	GameEvents.hunt_started.connect(_on_start_of_level)


func enter(_msg := {}) -> void:
	$"../../Pivot/AnimationPlayer".pause()
	$"../../BrickBasher".monitoring = false
	$"../../BrickBasher".monitorable = false

func update(delta: float) -> void:
	if end_of_level:
		owner.velocity.y += Param.GRAVITY_ON_FALL * delta
		if owner.is_on_floor():
			owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	else:
		owner.velocity.y = lerp(owner.velocity.y, 0.0, Param.FRICTION)
		owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()


func _on_end_of_day() -> void:
	end_of_level = true


func _on_start_of_level() -> void:
	end_of_level = false
