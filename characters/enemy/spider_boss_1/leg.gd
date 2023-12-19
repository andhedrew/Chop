@tool

extends Node2D

var leg_state := "Walk"
@export var start_point := 0.0
@export var back_leg := false
@onready var lower_leg_sprite := $Path2D/leg_lower/Sprite2D

var x_shift := 30
var chopped := 0
var health := 3
var leg_pos := -70.0

@export var leg_movement := 0.0
var leg_move_speed :=  0.061
# Called when the node enters the scene tree for the first time.
func _ready():
	$Path2D/leg_lower/Hurtbox.area_entered.connect(on_hurtbox_area_entered)
	if not Engine.is_editor_hint():
		z_index = SortLayer.PLAYER
		$Path2D/leg_lower.progress_ratio = start_point
		if not back_leg:
			position.x -= 80
			
		leg_movement = start_point
		leg_pos = -70.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not Engine.is_editor_hint():

		if chopped != 0:
			leg_pos = lerp(leg_pos, 0.0 + (90.0 * (chopped-1)), 0.2)
		else:
			leg_pos = lerp(leg_pos, -70.0, 0.2)
		
		$Path2D.position = Vector2(0.0, leg_pos)
		$Path2D/leg_upper.position = Vector2(0.0, -leg_pos)


		if leg_movement < 0.39 and leg_movement > 0.1:
			if chopped != 0:
				$Path2D/leg_lower/Sprite2D.frame = 3 + chopped
			else:
				$Path2D/leg_lower/Sprite2D.frame = 1
			leg_move_speed = lerp(leg_move_speed, 0.061, 0.5)
		elif leg_movement < 0.49:
			if chopped != 0:
				$Path2D/leg_lower/Sprite2D.frame = 3 + chopped
			else:
				$Path2D/leg_lower/Sprite2D.frame = 3
			leg_move_speed = lerp(leg_move_speed, 0.061, 0.5)
		else:
			if chopped != 0:
				$Path2D/leg_lower/Sprite2D.frame = 3 + chopped
			else:
				$Path2D/leg_lower/Sprite2D.frame = 0
#				lower_leg_sprite.frame = 0
			leg_move_speed = lerp(leg_move_speed, 0.25, 0.05)

		leg_movement += delta * leg_move_speed

		if leg_movement > 1.0:
			leg_movement = 0.0
		$Path2D/leg_lower.progress_ratio = leg_movement

func on_hurtbox_area_entered(area):
	if not Engine.is_editor_hint():
		if chopped < 3:
			GameEvents.new_vfx.emit("res://vfx/explosion.tscn", area.global_position)
			GameEvents.new_vfx.emit("res://vfx/blood_explosion.tscn", area.global_position)
			chopped +=1
		else:
			GameEvents.new_vfx.emit("res://vfx/explosion_big.tscn", area.global_position)
			GameEvents.new_vfx.emit("res://vfx/blood_explosion.tscn", area.global_position)
			GameEvents.new_vfx.emit("res://vfx/explosion_big.tscn", global_position)
			GameEvents.new_vfx.emit("res://vfx/blood_explosion.tscn", global_position)
			call_deferred("queue_free")
