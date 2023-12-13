extends State

var wait_time: float
var arm_detecting_smash := "right"
var arm_detecting_swipe := "right"

var fish_dead := true
var state: String = "Cast"
var pre_summon_smashes := 0

func _ready():
	$"../../ArmFrontRight/PlayerDetectorAttackRight".body_entered.connect(on_detect_player_smash_right)
	$"../../ArmFrontLeft/PlayerDetectorAttackLeft".body_entered.connect(on_detect_player_smash_left)
	$"../../ArmFrontRight/PlayerDetectorSwipeAttackRight".body_entered.connect(on_detect_player_swipe_right)
	$"../../ArmFrontLeft/PlayerDetectorSwipeAttackLeft".body_entered.connect(on_detect_player_swipe_left)
	GameEvents.fish_dead.connect(on_fish_all_dead)

func enter(_msg := {}) -> void:
	wait_time = randf_range(1.0, 3.0)

func update(_delta: float) -> void:
	if state_machine.state_timer > wait_time:
		var new_state = get_state()
		print_debug("new_state: " + str(new_state))
		state = new_state
		
		if state == "Cast":
			if not owner.arm_gone[arm_detecting_smash]:
				state_machine.transition_to("Cast", {"arm": arm_detecting_swipe})
		elif state == "Cry":
			state_machine.transition_to("Cry")
		elif state == "Smash":
			if not owner.arm_gone[arm_detecting_smash]:
				state_machine.transition_to("Smash", {"arm": arm_detecting_smash})
		elif state == "Summon":
			if fish_dead:
				GameEvents.spawn_fish.emit()
				fish_dead = false


func get_state() -> String:
	if state == "Cast":
		return "Cry"
	elif state == "Cry" and fish_dead and pre_summon_smashes >= 2:
		pre_summon_smashes = 0
		return "Summon"
	elif state == "Cry":
		pre_summon_smashes += 1
		return "Smash"
	else:
		return "Cast"
		
		

func on_detect_player_smash_right(body):
	arm_detecting_smash = "right"
	

func on_detect_player_smash_left(body):
	arm_detecting_smash = "left"
	

func on_detect_player_swipe_right(body):
	arm_detecting_swipe = "right"
	

func on_detect_player_swipe_left(body):
	arm_detecting_swipe = "left"
	


func on_fish_all_dead():
	fish_dead = true
	
