extends StaticBody2D


var particle_scene = preload("res://vfx/explosive_particles.tscn")
var slice_scene = preload("res://vfx/slice.tscn")
@export var texture: Texture
@onready var hurtbox := $Hurtbox

func _ready():
	hurtbox.area_entered.connect(_take_damage)

func _take_damage(area):
	if area is HitBox:
		_destroy()

func _destroy() -> void:
	var slice = slice_scene.instantiate()
	get_parent().add_child(slice)
	slice.position = position
	var explode = particle_scene.instantiate()
	explode.restart()
	explode.texture = texture
	var width : int = texture.get_width() / 16
	explode.material.set_particles_anim_h_frames(width)
	get_parent().add_child(explode)
	explode.position = position
	
	queue_free()
