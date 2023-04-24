extends Marker2D


@onready var animation_player := $"AnimationPlayer"

func _ready():
	animation_player.play("idle")
	GameEvents.started_feeding_little_brother.connect(_on_feeding)
	GameEvents.done_feeding_little_brother.connect(_on_done_feeding)



func _on_feeding() -> void:
	animation_player.play("eat")



func _on_done_feeding() -> void:
	animation_player.play("idle")
