class_name ParootBossEnemy
extends Enemy


func execute():
	$Pivot/Body.texture = preload("res://characters/enemy/paroot_boss/paroot_boss_phase_2.png")
	$StateMachine/Attack.set_script("res://characters/enemy/states/rush_attack.gd")
