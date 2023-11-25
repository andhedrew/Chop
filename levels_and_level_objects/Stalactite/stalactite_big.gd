extends Node2D

var bullet = preload("res://bullets/stalactite_bullet/stalactite_big_bullet.tscn")
var bullet_no_tip = preload("res://bullets/stalactite_bullet/stalactite_big_bullet_chopped.tscn")
var tip_bullet = preload("res://bullets/stalactite_bullet/stalactite_bullet.tscn")
@export var hazard := false
var fired_bullet := false

var fired_tip:= false

func _ready():
	if hazard:
		$SpriteHazard.visible = true
		$Sprite2D.visible = false
		$RayCast2D.enabled = true
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	$Hurtbox2.area_entered.connect(_on_hurtbox2_area_entered)
	if hazard:
		$Hurtbox.set_deferred("monitoring", false)
		$Hurtbox2.set_deferred("monitoring", false)

func _process(delta):
	if Engine.is_editor_hint():
		if hazard:
			$SpriteHazard.visible = true
			$Sprite2D.visible = false
		else:
			$SpriteHazard.visible = false
			$Sprite2D.visible = true
	else:
		if $RayCast2D.is_colliding():
			if not fired_bullet and not fired_tip:
				$Shield.monitoring = false
				_fire_bullet()
				

func _on_hurtbox_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", global_position)
			_fire_bullet()


func _on_hurtbox2_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			fired_tip = true
		
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", $Hurtbox2.global_position)
			_fire_tip_bullet()

func _fire_bullet():
	fired_bullet = true
	$Hurtbox.set_deferred("monitoring", false)
	$Hurtbox2.set_deferred("monitoring", false)
	$Sprite2D.frame = 1
	$SpriteHazard.frame = 1
	var bullet_inst
	if fired_tip:
		bullet_inst = bullet_no_tip.instantiate()
	else:
		bullet_inst = bullet.instantiate()
	owner.add_child(bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 200
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.hazard = hazard
	


func _fire_tip_bullet():
	$Hurtbox2.set_deferred("monitoring", false)
	$Sprite2D.frame = 2
	$SpriteHazard.frame = 2
	var bullet_inst = tip_bullet.instantiate()
	owner.add_child(bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 250
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.position = $Hurtbox2.global_position
	bullet_inst.hazard = hazard
	
