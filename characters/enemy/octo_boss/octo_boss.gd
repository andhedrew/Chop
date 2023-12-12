extends Enemy

var player_position: Vector2
@onready var player_detector := $PlayerDetector

var lost_left_arm := false
var lost_right_arm := false
var lost_left_eye := false
var lost_right_eye := false

var phase := 1

signal spawn
var spawn_timer := 0.0

func _ready():
	player_detector.body_entered.connect(_body_entered)
	$backArms.z_index = SortLayer.FOREGROUND
	z_index = SortLayer.FOREGROUND
	$CollisionShape2D.disabled = true


func _physics_process(delta):
	spawn_timer += delta
	if spawn_timer > 3:
		spawn_timer = 0.0
		GameEvents.spawn_fish.emit()
	if lost_left_arm:
		if lost_right_arm:
			if lost_left_eye:
				if lost_right_eye:
					queue_free()


func _body_entered(body) -> void:
	if body is Player:
		player_position = body.position

