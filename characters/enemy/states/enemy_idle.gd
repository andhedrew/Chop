extends State

var wait_time := 2
var transitioned := false

# Called when the node enters the scene tree for the first time.
func enter(_msg := {}) -> void:
	owner.animation_player.play("idle")
	transitioned = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(_delta: float) -> void:
	owner.velocity.x = lerp(owner.velocity.x, 0.0, Param.FRICTION)
	owner.move_and_slide()
	
	if !transitioned:
		transitioned = true
		await get_tree().create_timer(wait_time).timeout
		state_machine.transition_to("Walk")

	if !owner.is_on_floor():
		state_machine.transition_to("Fall")
