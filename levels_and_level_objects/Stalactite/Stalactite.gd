extends Node2D

var bullet = preload("res://bullets/stalactite_bullet/stalactite_bullet.tscn")
@export var hazard := false
var fired_bullet := false

func _ready():
	if hazard:
		$SpriteHazard.visible = true
		$Sprite2D.visible = false
		$RayCast2D.enabled = true
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)

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
			if not fired_bullet:
				_fire_bullet()
				fired_bullet = true

func _on_hurtbox_area_entered(area) -> void:
	if not Engine.is_editor_hint():
		if area is HitBox:
			GameEvents.new_vfx.emit("res://vfx/slice.tscn", global_position)
			_fire_bullet()


func _fire_bullet():
	$Hurtbox.set_deferred("monitoring", false)
	$Sprite2D.frame = 1
	var bullet_inst = bullet.instantiate()
	owner.call_deferred("add_child", bullet_inst)
	var transform = global_transform
	var fire_range = 100
	var speed = 250
	var spread = 0
	var rotation := 90

	bullet_inst.setup(transform, fire_range, speed, rotation, spread)
	bullet_inst.position = $Hurtbox.global_position
	bullet_inst.hazard = hazard

