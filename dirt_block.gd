extends CharacterBody2D
@onready var hit_box := $Hitbox

func _ready():
	$Hurtbox.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	
	velocity.y += Param.GRAVITY*.02
	var colliding = move_and_collide(velocity*delta)
	if colliding:
		velocity.y = 0
		hit_box.monitorable = false
		hit_box.position.y = -32
	else:
		hit_box.monitorable = true
		hit_box.position.y = lerp(hit_box.position.y, -16.0, .5)


func _on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if !hitbox.fire and !hitbox.syphon:
			var dirt := preload("res://vfx/dirt_explode.tscn").instantiate()
			dirt.restart()
			dirt.position = global_position
			get_node("/root/").add_child(dirt)
			queue_free()
	hitbox.owner._destroy()
