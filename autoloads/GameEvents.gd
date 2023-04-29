extends Node

signal player_changed_facing
signal player_attacked
signal player_executed
signal player_changed_state
signal player_health_changed
signal player_started_syphoning #Arg 1: player.global_position
signal player_done_syphoning
signal double_jump_refreshed
signal added_food_to_bag
signal removed_food_from_bag
signal charge_amount_changed
signal enemy_took_damage
signal bag_capacity_changed
signal enemy_being_syphoned
signal started_feeding_little_brother
signal done_feeding_little_brother
signal player_money_changed #pass current amount of money


# Game State signals

signal cutscene_started
signal cutscene_ended

signal evening_started 
signal evening_ended

signal transition_to_map
signal map_started

signal morning_started

