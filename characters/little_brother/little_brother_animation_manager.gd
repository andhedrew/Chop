extends Marker2D


@onready var animation_player := $"AnimationPlayer"
@onready var emotion_bubble := $"EmotionBubble"

func _ready():
	animation_player.play("idle")
	emotion_bubble.visible = false
	GameEvents.started_feeding_little_brother.connect(_on_feeding)
#	GameEvents.done_feeding_little_brother.connect(_on_done_feeding)
	GameEvents.evening_started.connect(_on_evening_start)
	GameEvents.morning_started.connect(_on_start_of_day)
	GameEvents.continue_day.connect(_on_continue_day)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)


func _process(delta):
	match owner.state:
		Enums.State.MOVE:
			animation_player.play("walk")
		Enums.State.IDLE:
			animation_player.play("idle")
		Enums.State.PLAYER_ON_BEAK:
			animation_player.play("player_on_beak")
		Enums.State.HUNGRY:
			animation_player.play("hungry")



func _on_feeding() -> void:
	animation_player.play("eat")


func _on_evening_start() -> void:
	await get_tree().create_timer(8.0).timeout
	animation_player.play("go_to_sleep")
	await animation_player.animation_finished
	animation_player.play("sleep")


func _on_start_of_day() -> void:
	animation_player.play("wake")
	await get_tree().create_timer(3.0).timeout
	owner.state = Enums.State.MOVE

func _on_continue_day() -> void:
	$"../FullMessage".visible = false
	await get_tree().create_timer(3.0).timeout
	owner.state = Enums.State.MOVE

func _on_cutscene_start() -> void:
	owner.state = Enums.State.CUTSCENE

func _on_cutscene_end() -> void:
	owner.state = Enums.State.IDLE
