extends State

var speed = 200 # Speed of the object
var max_speed = 98
var direction = Vector2(0, 1) # Initial direction
var start_position # To store the start position
var go_home := false
var wait := false
var hit_ground = false
var chop_counter := 0

func enter(msg := {}) -> void:
	GameEvents.octo_dead.emit()
	start_position = owner.global_position
	$"../../DeadHurtbox".area_entered.connect(_on_hurtbox_area_entered)
	$"../../DeadHurtbox".set_deferred("monitoring", true)
	
	direction = direction.normalized() # Ensure the direction is normalized
	speed = 0


func physics_update(delta: float) -> void:
	var collision_info = owner.move_and_collide(direction * speed * delta)
	if not collision_info:
		if speed < max_speed:
			speed += 1
	elif not hit_ground:
		GameEvents.boss_hit_wall.emit()
		hit_ground = true


func _on_hurtbox_area_entered(hitbox):
	if hitbox is HitBox:
		if hitbox.execute:
			GameEvents.octo_chopped.emit()
			chop_counter += 1
			if chop_counter >= 3:
				owner.execute()
