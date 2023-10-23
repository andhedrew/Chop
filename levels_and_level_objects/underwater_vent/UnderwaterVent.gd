extends Node2D

var push_strength = 60.0  # Adjust this value to change the strength of the push
var bodies_in_fan = []  # Array to store bodies in the fan
@export var max_speed = 200  # replace with your maximum speed
@export_category("Rust")
@export var rusty := false
@export var stays_rusty := false
@export var run_time_before_stopping := 4.0

@export_category("Interval")
@export var blows_on_interval := false
@export var interval_time := 0.0

var activating := false
var fan_running := false



func _ready():
	fan_running = true
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Hurtbox.area_entered.connect(_on_area_entered_hurtbox)


func _physics_process(_delta):
	for body in bodies_in_fan:
		var direction = Vector2.UP.rotated(rotation)
		body.velocity += direction * push_strength
		var speed = body.velocity.length()
		if speed > max_speed:
			body.velocity = body.velocity.normalized() * max_speed


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
