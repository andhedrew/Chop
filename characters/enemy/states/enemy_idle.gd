extends State

@onready var animation_player := $"../../Pivot/AnimationPlayer"
@onready var effects_player := $"../../Pivot/EffectsPlayer"

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	animation_player.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	
	if not owner.is_on_floor():
		state_machine.transition_to("enemy_fall")
