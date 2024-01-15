extends LevelManager



func _ready():
	super._ready()
#	GameEvents.cutscene_started.emit()
	GameEvents.wave_level_start.emit()
#	if not SaveManager.load_item("wave_triggered"):
#		SaveManager.save_item("wave_triggered", true)


