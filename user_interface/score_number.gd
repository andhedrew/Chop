extends Node2D


var score := 100

func _process(delta):
	$Label.text = str(score)
