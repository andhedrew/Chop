extends Node2D


@onready var split_focus_area : Area2D = $SplitFocusArea
@onready var full_focus_area : Area2D = $MainFocusArea


# Called when the node enters the scene tree for the first time.
func _ready():
	full_focus_area.body_entered.connect(_on_body_entered)
	full_focus_area.body_exited.connect(_on_body_exited)
	split_focus_area.body_entered.connect(_on_body_entered_split)
	split_focus_area.body_exited.connect(_on_body_exited_split)


func _on_body_entered(body) ->void:
	if body is Player:
		GameEvents.camera_change_focus.emit(self)


func _on_body_exited(body) ->void:
	if body is Player:
		GameEvents.camera_change_focus.emit(body)


func _on_body_entered_split(body) ->void:
	if body is Player:
		GameEvents.camera_split_focus.emit(self, false)


func _on_body_exited_split(body) ->void:
	if body is Player:
		GameEvents.camera_split_focus.emit(self, true)
		GameEvents.camera_change_focus.emit(body)
