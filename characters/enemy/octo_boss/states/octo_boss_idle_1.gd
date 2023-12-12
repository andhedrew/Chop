extends State

var wait_time: float
var arm_detecting_smash := "right"
var arm_detecting_swipe := "right"

var state_odds: Dictionary = {"Cry": 1.0, "Smash": 1.0, "Cast": 1.0}
const ODDS_INCREASE = 2.0
const ODDS_DECREASE = 0.5


func _ready():
	$"../../ArmFrontRight/PlayerDetectorAttackRight".body_entered.connect(on_detect_player_smash_right)
	$"../../ArmFrontLeft/PlayerDetectorAttackLeft".body_entered.connect(on_detect_player_smash_left)
	$"../../ArmFrontRight/PlayerDetectorSwipeAttackRight".body_entered.connect(on_detect_player_swipe_right)
	$"../../ArmFrontLeft/PlayerDetectorSwipeAttackLeft".body_entered.connect(on_detect_player_swipe_left)

func enter(_msg := {}) -> void:
	wait_time = randf_range(3.0, 6.0)

func update(_delta: float) -> void:
	if state_machine.state_timer > wait_time:
		var state = get_weighted_random_state()
		if state == "Smash":
			state_machine.transition_to("Smash", {"arm": arm_detecting_smash})
			state_odds["Smash"] *= ODDS_DECREASE
		elif state == "Cast":
			state_machine.transition_to("Cast", {"arm": arm_detecting_swipe})
			state_odds["Cast"] *= ODDS_DECREASE
		else:
			state_machine.transition_to("Cry")
		adjust_state_odds(state)

func get_weighted_random_state() -> String:
	var total_odds = 0.0
	for odds in state_odds.values():
		total_odds += odds
	
	var random_point = randf() * total_odds
	for state in state_odds.keys():
		var odds = state_odds[state]
		if random_point < odds:
			return state
		random_point -= odds

	return "Cry" # Fallback

func adjust_state_odds(selected_state: String) -> void:
	for state in state_odds.keys():
		if state == selected_state:
			state_odds[state] *= ODDS_DECREASE
		else:
			state_odds[state] *= ODDS_INCREASE

func on_detect_player_smash_right(body):
	arm_detecting_smash = "right"
	state_odds["Smash"] *= ODDS_INCREASE

func on_detect_player_smash_left(body):
	arm_detecting_smash = "left"
	state_odds["Smash"] *= ODDS_INCREASE

func on_detect_player_swipe_right(body):
	arm_detecting_swipe = "right"
	state_odds["Cast"] *= ODDS_INCREASE

func on_detect_player_swipe_left(body):
	arm_detecting_swipe = "left"
	state_odds["Cast"] *= ODDS_INCREASE
