extends Area2D

var has_trilled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_trill)
	GameEvents.done_feeding_little_brother.connect(_reset_trill)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _reset_trill() -> void:
	has_trilled = false


func _trill(_body) -> void:
	if !has_trilled:
		owner.state = Enums.State.TRILL
		SoundPlayer.play_sound("lil_bro_trill")
		await get_tree().create_timer(1.0).timeout
		owner.state = Enums.State.IDLE
		has_trilled = true
