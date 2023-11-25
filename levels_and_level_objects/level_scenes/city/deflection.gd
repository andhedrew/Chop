extends Area2D

var which_parry := 1
var block_timer := Timer.new()

func _ready():
	self.area_entered.connect(_on_hit_by_projectile)
	add_child(block_timer)


func _on_hit_by_projectile(area) -> void:
	var slice = preload("res://vfx/deflect.tscn").instantiate()
	slice.position.x = area.global_position.x
	slice.position.y = area.global_position.y
	get_node("/root/World").add_child(slice)
#	area.get_parent().call_deferred("queue_free")
	
