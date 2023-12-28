extends CharacterBody2D

@export var death_pieces: Array[Resource]
@onready var hurtbox := $Hurtbox
var particle_scene = preload("res://vfx/explosive_particles.tscn")
@export var particle_texture: Texture
var speed = 80.0
var turning = false
var cutscene_running = false

func _ready():
	await get_tree().create_timer(0.2).timeout
	hurtbox.area_entered.connect(_take_damage)


func _physics_process(delta):
	if cutscene_running:
		return
	velocity.x = speed
	if !is_on_floor():
		velocity.y += Param.GRAVITY * delta
	move_and_slide()
	if $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		if is_on_floor():
			if !turning:
				turning = true
				speed = -speed
				await get_tree().create_timer(0.5).timeout
				turning = false
		
	
func _take_damage(hitbox) -> void:
	if hitbox is HitBox:
		GameEvents.enemy_took_damage.emit(0)
		die()
		

func die() -> void:
	OS.delay_msec(80)
	GameEvents.mush_destroyed.emit()
	var explode = particle_scene.instantiate()
	explode.restart()
	explode.texture = particle_texture
	var width : int = particle_texture.get_width() / 16
	explode.material.set_particles_anim_h_frames(width)
	get_parent().add_child(explode)
	explode.position = position
	
	GameEvents.new_vfx.emit("res://vfx/explosion.tscn", global_position)
	GameEvents.drop_food.emit(death_pieces, Vector2(global_position.x, global_position.y - 5))
	queue_free()


func _on_start_cutscene() -> void:
	cutscene_running = true


func _on_end_cutscene() -> void:
	cutscene_running =  false
