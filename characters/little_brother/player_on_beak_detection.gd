extends Area2D

func _ready():
	self.body_entered.connect(_player_on_beak)
	self.body_exited.connect(_player_off_beak)



func _player_on_beak(_body) -> void:
	owner.state = Enums.State.PLAYER_ON_BEAK


func _player_off_beak(_body) -> void:
	owner.state = Enums.State.IDLE
