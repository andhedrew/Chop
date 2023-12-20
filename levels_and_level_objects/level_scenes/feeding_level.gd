extends LevelManager


func _ready():
	super._ready()
	if not SaveManager.load_item("spider_triggered"):
		GameEvents.cutscene_started.emit()
		GameEvents.feeding_level_start.emit()
	else:
		$AreaOfInterest.queue_free()
		GameEvents.start_spider_chase.emit()
