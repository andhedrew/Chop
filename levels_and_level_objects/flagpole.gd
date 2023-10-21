extends Area2D


var score := 0.0
var score_chosen := false

func _ready():
	self.area_entered.connect(_on_area_entered)


func _physics_process(delta):
	$ScoreMarker.scale.x = lerp($ScoreMarker.scale.x, 1.0, 0.4)

func _on_area_entered(area):

	if area is HitBox and not score_chosen:
		score_chosen = true
		$ScoreMarker.global_position.y = area.global_position.y
		$ScoreMarker.global_position.y = max(area.global_position.y, -225)
		score = abs(($ScoreMarker.global_position.y/225)*100)
		score = round(score)
		if score == 99:
			$ScoreMarker/Head.visible = true
		else:
			$ScoreMarker/Head.visible = false
		if score == 100:
#			GameEvents.new_vfx.emit("res://vfx/slice_big.tscn", $ScoreMarker.global_position)
			$ScoreMarker.scale.x = 20.0
			GameEvents.new_vfx.emit("res://vfx/firework.tscn", $ScoreMarker.global_position)
		else:
			$ScoreMarker.scale.x = 3.0
		$ScoreMarker/Label.text = str(score)
		$ScoreMarker.visible = true

		GameEvents.player_score_changed.emit(int(score), false)
