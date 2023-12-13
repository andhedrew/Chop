extends Enemy

var player_position: Vector2
@onready var player_detector := $PlayerDetector

var arm_gone = {
	"left": false,
	"right": false,
}

var eye_gone = {
	"left": false,
	"right": false,
}


var phase := 1


func _ready():
	$AnimationPlayer.play("RESET")
	player_detector.body_entered.connect(_body_entered)
	$backArms.z_index = SortLayer.FOREGROUND
	z_index = SortLayer.FOREGROUND
	$CollisionShape2D.disabled = true


func _physics_process(delta):

	if arm_gone["left"]:
		if arm_gone["right"]:
			if eye_gone["left"]:
				if eye_gone["right"]:
					queue_free()


func _body_entered(body) -> void:
	if body is Player:
		player_position = body.position

