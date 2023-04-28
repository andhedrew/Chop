extends Marker2D


@onready var animation_player := $"AnimationPlayer"

func _ready():
	animation_player.play("idle")
	GameEvents.started_feeding_little_brother.connect(_on_feeding)
	GameEvents.done_feeding_little_brother.connect(_on_done_feeding)
	GameEvents.evening_started.connect(_on_evening_start)
	GameEvents.morning_started.connect(_on_start_of_day)



func _on_feeding() -> void:
	animation_player.play("eat")



func _on_done_feeding() -> void:
	animation_player.play("idle")


func _on_evening_start() -> void:
	await get_tree().create_timer(8.0).timeout
	animation_player.play("go_to_sleep")
	await animation_player.animation_finished
	animation_player.play("sleep")


func _on_start_of_day() -> void:
	animation_player.play("wake")
	await get_tree().create_timer(3.0).timeout
	animation_player.play("walk")
	owner.state = Enums.State.MOVE
	
