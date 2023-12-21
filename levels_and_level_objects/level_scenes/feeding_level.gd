extends LevelManager


func _ready():
	super._ready()
	GameEvents.spider_boss_killed.connect(on_spider_boss_killed)
	if not SaveManager.load_item("spider_triggered"):
		GameEvents.cutscene_started.emit()
		GameEvents.feeding_level_start.emit()
	else:
		$AreaOfInterest.queue_free()
		GameEvents.start_spider_chase.emit()



func on_spider_boss_killed():
	transition_to_level("res://user_interface/end_menu.tscn")
