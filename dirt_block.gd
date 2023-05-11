extends CharacterBody2D
@onready var hit_box := $Hitbox


@export var bounty := 1

func _ready():
	$Hurtbox.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	velocity.y += Param.GRAVITY*.02
	var colliding = move_and_collide(velocity*delta)
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		velocity.y = 0
		hit_box.monitorable = false
		set_collision_layer_value(1, true)
	else:
		hit_box.monitorable = true
		set_collision_layer_value(1, false)
		if $PlayerEnemyDetector.is_colliding() or $PlayerEnemyDetector2.is_colliding() or $PlayerEnemyDetector3.is_colliding():
			$CollisionShape2D.queue_free()
			_destroy()
		

func _on_area_entered(hitbox) -> void:
	if hitbox is HitBox:
		if !hitbox.fire and !hitbox.syphon:
			
			_destroy()
	hitbox.owner._destroy()


func _destroy() -> void:
	var dirt := preload("res://vfx/dirt_explode.tscn").instantiate()
	SoundPlayer.play_sound("dirt")
	dirt.restart()
	dirt.position = global_position
	get_node("/root/").add_child(dirt)
	randomize()
	var options = [1, 2, 3]
	var rand_index: int = randi() % options.size()
	if bounty == 8:
		rand_index = 1
	if rand_index == 1:
		var spread = 6 # adjust this value to increase or decrease the spread of the pickups
		var new_velocity = Vector2(0, -12) # adjust this value to control the initial velocity of the pickups
		if bounty > 0:
			var coins = [8, 4, 2, 1]
			var total_coins = 0
			var bounty_tracker = bounty
			for coin in coins:
				total_coins += int(bounty_tracker / coin)
				if coin <= bounty_tracker:
					bounty_tracker = bounty_tracker % coin
			bounty = int(bounty)
			var i = 0
			for coin in coins:
				while bounty >= coin:
					var pickup = preload("res://pickups/coin_pickup.tscn").instantiate()
					var angle = i * 2 * PI / total_coins
					i += 1
					pickup.position = global_position + Vector2(cos(angle), sin(angle)) * spread
					pickup.velocity = new_velocity.rotated(angle)
					pickup.value = coin
					get_node("/root/").call_deferred("add_child", pickup)
					bounty -= coin
	elif rand_index == 2:
		var sprite := preload("res://user_interface/healthbar/full_heart.png")
		var pickup := preload("res://pickups/health_pickup.tscn").instantiate()
		pickup.setup(sprite)
		pickup.position = global_position
		get_node("/root/").call_deferred("add_child", pickup)
	elif rand_index == 3:
		pass
	queue_free()
