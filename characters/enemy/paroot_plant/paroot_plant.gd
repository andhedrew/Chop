extends Enemy

func _ready():
	super._ready()
	GameEvents.player_died.connect(_on_player_die)

func _take_damage(_hitbox) -> void:
	$StateMachine/Idle.take_damage()


func _on_player_die():
	$StateMachine/Idle.take_damage()
