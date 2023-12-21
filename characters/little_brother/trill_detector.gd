extends Area2D

var has_trilled = false
var cutscene_running := false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_trill)
	GameEvents.done_feeding_little_brother.connect(_reset_trill)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	GameEvents.cutscene_started.connect(_on_cutscene_begin)
	GameEvents.start_spider_chase.connect(_disable)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _reset_trill() -> void:
	has_trilled = false


func _trill(_body) -> void:
	if !has_trilled and !cutscene_running:
		owner.state = Enums.State.TRILL
		SoundPlayer.play_sound("lil_bro_trill")
		await get_tree().create_timer(1.0).timeout
		owner.state = Enums.State.IDLE
		has_trilled = true


func _on_cutscene_end() -> void:
	cutscene_running = false

func _on_cutscene_begin() -> void:
	cutscene_running = true


func _disable():
	set_deferred("monitoring", false)
