extends Node2D


var score := 100

func _process(_delta):
	$Label.text = str(score)