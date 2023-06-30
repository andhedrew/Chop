extends StaticBody2D

@onready var hitbox := $Hitbox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hitbox.position.y == 4:
		hitbox.position.y = 16
	else:
		hitbox.position.y = 4
		
