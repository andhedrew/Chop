extends Enemy


var phase := 1
var player_scene: CharacterBody2D
var seeing_player := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Shoulder_back.z_index = SortLayer.FOREGROUND
	$PlayerDetector.body_entered.connect(_on_body_entered)
	$PlayerDetector.body_exited.connect(_on_body_exited)
	GameEvents.start_spider_chase.connect(_on_chase_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	var leg_count_back := $Shoulder_back.get_child_count()
	var leg_count_front := $Shoulder.get_child_count()
	for child in leg_count_back:
		var leg = $Shoulder_back.get_child(child)

	if leg_count_back + leg_count_front < 3:
		_die()

		


func _on_body_entered(body):
	if body is Player:
		player_scene = body
		seeing_player = true
		print( "I SEE YOU")


func _on_body_exited(body):
	if body is Player:
		seeing_player = false
		print( "I DONUT SEE YOU")


func _on_chase_start():
	GameEvents.camera_change_focus.emit(self)
	await get_tree().create_timer(2.5).timeout
	GameEvents.camera_reset_focus.emit()
	GameEvents.cutscene_ended.emit()


func _die():
	await get_tree().create_timer(2.0).timeout
	GameEvents.spider_boss_killed.emit()
	call_deferred("queue_free")
