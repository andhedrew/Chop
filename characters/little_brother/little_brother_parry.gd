extends Area2D

var which_parry := 1
var block_timer := Timer.new()

func _ready():
	self.area_entered.connect(_on_hit_by_projectile)
	add_child(block_timer)
	block_timer.timeout.connect(_on_block_timer_timeout)

func _process(_delta):
	pass

func _on_hit_by_projectile(_area) -> void:
	owner.state = Enums.State.BLOCK
	block_timer.start(2)
	var slice = preload("res://vfx/slice.tscn").instantiate()
	slice.position.x = global_position.x + 50
	slice.position.y = global_position.y
	get_node("/root/World").add_child(slice)
	SoundPlayer.play_sound_positional("ping", global_position)
	match which_parry:
		1: 
			$"../Pivot/AnimationPlayer".play("parry_1")
			which_parry = 2
			
		2: 
			$"../Pivot/AnimationPlayer".play("parry_2")
			which_parry = 1

func _on_block_timer_timeout():
	block_timer.stop()
	owner.state = Enums.State.IDLE
