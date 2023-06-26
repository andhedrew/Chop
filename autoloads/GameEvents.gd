extends Node

signal player_changed_facing
signal player_attacked
signal player_executed
signal big_explosion
signal player_changed_state
signal player_health_changed # Arg 1: health Arg 2: Max health
signal player_started_syphoning #Arg 1: player.global_position
signal player_done_syphoning
signal player_died
signal double_jump_refreshed
signal added_food_to_bag # Arg 1: the food_pickup
signal removed_food_from_bag
signal bag_full
signal charge_amount_changed # Arg 1: Torch Charges Arg 2: Max charges
signal enemy_took_damage
signal bag_capacity_changed
signal enemy_being_syphoned
signal started_feeding_little_brother
signal done_feeding_little_brother
signal player_money_changed #pass current amount of money
signal hunt_started

# Game State signals

signal cutscene_started
signal cutscene_ended

signal dialogue_started
signal dialogue_finished

signal morning_started
signal continue_day
signal evening_started 
signal evening_ended

signal transition_to_map
signal map_started

signal SaveDataReady


#boss
signal boss_stomped
signal boss_hit_wall
signal boss_defeated

#utility
signal camera_change_focus #Param 1: new node target
signal camera_reset_focus

# Drops
signal drop_food # Arg 1: array of sprites # Arg 2: Position
signal drop_health # Arg 1: Position
signal drop_coins # Arg 1: amount to drop (bounty) # Arg 2: Position
signal new_vfx  #arg 1: String reference to VX # Arg 2: Position
# tutorial
signal plant_hunger_bar_filled # no parameters



