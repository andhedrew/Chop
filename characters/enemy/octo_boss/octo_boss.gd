extends Enemy

var player_position: Vector2
@onready var player_detector := $PlayerDetector

func _ready():
	player_detector.body_entered.connect(_body_entered)
	$backArms.z_index = SortLayer.FOREGROUND




func _physics_process(delta):
	pass


func _body_entered(body) -> void:
	if body is Player:
		player_position = body.position

