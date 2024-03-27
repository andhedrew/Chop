extends LevelManager

@export var dream_images: Array[Texture]

func _ready():
	super._ready()
	GameEvents.evening_ended.connect(_on_evening_ended)
	SoundPlayer.stop_music()
	#GameEvents.spider_boss_killed.connect(on_spider_boss_killed)
	if not SaveManager.load_item("spider_triggered"):
		GameEvents.cutscene_started.emit()
		GameEvents.feeding_level_start.emit()
	else:
		$AreaOfInterest.queue_free()
		GameEvents.start_spider_chase.emit()



func on_spider_boss_killed():
	transition_to_level("res://user_interface/end_menu.tscn")


func _on_evening_ended() -> void:
	var dream := preload("res://levels_and_level_objects/dream/dream.tscn").instantiate()
	dream.get_node("Dream/Sprite2D").texture = dream_images[0]
	dream.dream_slides = dream_images
	add_child(dream)
