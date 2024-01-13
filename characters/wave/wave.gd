extends Node2D

@export var speed := 100


# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta


func _on_body_entered(body) -> void:
	if body is Player:
		GameEvents.restart_level.emit()
