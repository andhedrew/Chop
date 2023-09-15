extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body) ->void:
	if body is Player:
		GameEvents.camera_change_focus.emit(self)


func _on_body_exited(body) ->void:
	if body is Player:
		GameEvents.camera_change_focus.emit(body)
