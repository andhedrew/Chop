extends Node2D

@export var speed := 100


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	GameEvents.wave_level_start.connect(_on_start_of_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta


func _on_body_entered(body) -> void:
	if body is Player:
		GameEvents.restart_level.emit()


func _on_start_of_level():
	GameEvents.camera_change_focus.emit(self)
	await get_tree().create_timer(2.5).timeout
	GameEvents.camera_reset_focus.emit()
	GameEvents.cutscene_ended.emit()
