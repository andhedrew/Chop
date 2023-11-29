extends Area2D

var bodies_bouncing = []  # Array to store bodies in the fan
var bounce_strength = 50

@onready var head := $head
@onready var mouth := $mouth
@onready var nose := $nose
@onready var eyes := $eyes

@onready var outline := $outline
@onready var deets := $detail

var original_pos: Vector2


func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	original_pos = head.position
	z_index = SortLayer.FOREGROUND
	$Hurtbox.area_entered.connect(_get_angry)
	randomize_frames()

func _physics_process(delta):
		for body in bodies_bouncing:
			var direction = body.global_position - global_position
			direction = direction.normalized()
			body.velocity += direction * bounce_strength
			var pop_strength = -150
			body.velocity.y = pop_strength
			head.position -= direction
			var mult := 0.8
			for sprite in [mouth, eyes, deets]:
				sprite.position -= direction*mult
			
			mult = 1.1
			nose.position -= direction*mult
			
		
		if head.position != original_pos:
			head.position = lerp(head.position, original_pos, 0.2)
		for sprite in [mouth, nose, eyes, deets]:
				if sprite.position != original_pos:
					sprite.position = lerp(sprite.position, original_pos, 0.1)


func randomize_frames():
	for sprite in [head, mouth, nose, eyes, outline, deets]:
		sprite.frame = 0
#		sprite.frame = randi() % (sprite.hframes - 1) + 1


func _on_body_entered(body) -> void:
	if body is Player or body is Enemy:
		bodies_bouncing.append(body)


func _on_body_exited(body) -> void:
	if body in bodies_bouncing:
		bodies_bouncing.erase(body)


func _get_angry(area):
	if area is HitBox:
		if area.execute:
			for sprite in [head, mouth, nose, eyes, outline, deets]:
				sprite.frame = 0
			
			bounce_strength = 100
