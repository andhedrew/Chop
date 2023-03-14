extends State

@onready var animation_player := $"../../Pivot/AnimationPlayer"
@onready var effects_player := $"../../Pivot/EffectsPlayer"

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	
	if not owner.is_on_floor():
		state_machine.transition_to("enemy_fall")
