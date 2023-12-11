extends State

func _ready():
	$"../../ArmFrontRight/PlayerDetectorAttackRight".body_entered.connect(on_detect_player_right)
	$"../../ArmFrontLeft/PlayerDetectorAttackLeft".body_entered.connect(on_detect_player_left)
func enter(_msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	var target = owner.player_position.x
	owner.position.x = lerp(owner.position.x, target, 0.02)


func physics_update(_delta: float) -> void:
	pass


func exit() -> void:
	pass


func on_detect_player_right(body):
	$"../../AnimationPlayer".play("smash_arm_right")
	state_machine.transition_to("Smash", {"arm": "right"})
	


func on_detect_player_left(body):
	$"../../AnimationPlayer".play("smash_arm_left")
	state_machine.transition_to("Smash", {"arm": "left"})
