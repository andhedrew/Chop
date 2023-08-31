extends LevelManager


func _ready():
	super._ready()
	GameEvents.cutscene_started.emit()
	GameEvents.feeding_level_start.emit()
