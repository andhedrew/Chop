@tool

extends Node2D

var push_strength = 80.0  # Adjust this value to change the strength of the push
var bodies_in_fan = []  # Array to store bodies in the fan
@export var max_speed = 200  # replace with your maximum speed
var base_speed := 200.0
@export_category("Rust")
@export var rusty := false
@export var stays_rusty := false
@export var run_time_before_stopping := 4.0
@export_category("Rotation")
@export var rotating := false
@export var rotation_speed := 0.5
@export var starting_angle := 0

@export_category("Interval")
@export var blows_on_interval := false
@export var interval_time := 0.0

var activating := false
var fan_running := false



func _ready():
	
	$Body/AnimatedSprite2D.speed_scale = float(max_speed/base_speed)
	
	if not Engine.is_editor_hint():
		if rusty:
			$Body/BlowParticles.emitting = false
			activating = false
			$Body/AnimatedSprite2D.animation = "rusty"
		else:
			fan_running = true
			var running_sound = SoundPlayer.play_sound_positional("fan_running", position, 140)
			running_sound.pitch_scale = float(max_speed/base_speed)
			SoundPlayer.play_sound_positional("fan_blow", position, 250)

		$Body/Area2D.body_entered.connect(_on_body_entered)
		$Body/Area2D.body_exited.connect(_on_body_exited)
		$Body/Hurtbox.area_entered.connect(_on_area_entered_hurtbox)
	
		$Body.rotation = rotation
		rotation = 0
	
	if rotating:
		$Body.rotation_degrees = starting_angle
		$RotationThing.visible = true
		$RotationThing.z_index = SortLayer.FOREGROUND
		$RotationThing.rotation = 0
	else:
		$RotationThing.visible = false
#
	var particles = $Body/BlowParticles
	var process_material = particles.process_material as ParticleProcessMaterial
	var life = (200/max_speed) * 0.4
	if life > 0:
		particles.lifetime = life
	else:
		particles.lifetime = 0.4
	
	if process_material:
		var new_material = process_material.duplicate()
		particles.process_material = new_material
		var new_process_material = particles.process_material
		new_process_material.initial_velocity_min = float(max_speed - 50.0)
		new_process_material.initial_velocity_max = float(max_speed + 50.0)
		
		

func _physics_process(delta):
	if Engine.is_editor_hint():
		if stays_rusty and !rusty:
			rusty = true
	
	if rotating:
		$Body.rotation += (rotation_speed * delta)
	if not Engine.is_editor_hint():
		if not fan_running:
			if activating:
				SoundPlayer.play_sound("metal_clang")
				var snd_1 = SoundPlayer.play_sound_positional("fan_running", position, 140)
				var snd_2 = SoundPlayer.play_sound_positional("fan_blow", position, 250)
				fan_running = true
				$Body/RustParticles.restart()
				$Body/BlowParticles.emitting = true
				
				if stays_rusty:
					$Body/RustParticles.amount = 10
					$Body/AnimatedSprite2D.animation = "new_animation" #GODOT WONT LET ME CHANGE THE ANIMATION NAME AT THIS TIME DONT GET ANGRY WITH ME
					activating = false
					await get_tree().create_timer(run_time_before_stopping).timeout
					SoundPlayer.play_sound("fan_stop")
					$Body/RustParticles.restart()
					$Body/BlowParticles.emitting = false
					$Body/AnimatedSprite2D.animation = "rusty"
					snd_1.call_deferred("queue_free")
					snd_2.call_deferred("queue_free")
					fan_running = false
				else:
					$Body/AnimatedSprite2D.animation = "default"
					rusty = false
					activating = false

		else:
			for body in bodies_in_fan:
				var direction = Vector2.UP.rotated($Body.rotation)
				body.velocity += direction * push_strength
				var speed = body.velocity.length()
				if speed > max_speed:
					body.velocity = body.velocity.normalized() * max_speed


	
	if Engine.is_editor_hint():
		if rusty:
			$Body/AnimatedSprite2D.animation = "rusty"
		else:
			$Body/AnimatedSprite2D.animation = "default"


func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_in_fan.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_in_fan:
		bodies_in_fan.erase(body)


func _on_area_entered_hurtbox(area) -> void:
	if area is HitBox:
		if rusty:
			if area.execute:
				activating = true
