extends Node

signal player_changed_facing
signal player_attacked
signal player_executed
signal big_explosion
signal player_changed_state
signal player_health_changed # Arg 1: health Arg 2: Max health
signal player_score_changed # Arg 1: score to add to total Arg 2: "true" to reset
signal player_started_syphoning #Arg 1: player.global_position
signal player_done_syphoning
signal player_died
signal player_hit_enemy #arg 1: the enemy

signal refresh_execute

signal player_falling # Arg 1: True or false? Is he falling or not?


signal added_food_to_bag # Arg 1: the food_pickup
signal removed_food_from_bag
signal bag_full
signal charge_amount_changed # Arg 1: Torch Charges Arg 2: Max charges
signal add_a_charge
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

signal morning_started #start of level
signal continue_day #end of level
signal feeding_level_start
signal evening_started 
signal evening_ended


signal transition_to_map #Arg 1: Map Scene Arg 2: Position on map (1-4) Arg 3: Next level (after map)
signal map_started

signal SaveDataReady

signal restarted_level
signal bullet_hit_breakable #Arg 1: global_position of bullet


#boss
signal boss_stomped
signal boss_hit_wall
signal boss_defeated
signal spawn_fish
signal fish_dead
signal octo_dead
signal octo_chopped
signal start_octo_battle
signal end_octo_battle
signal spider_boss_killed
#spider
signal lil_bro_died
signal start_spider_chase
#utility
signal camera_change_focus #Param 1: new node target
signal camera_split_focus #Param 1: new node target, or FALSE if we want to stop.
signal camera_reset_focus
signal replace_tile #replace a ghost tile. Param 1: Global position
signal cheatmode

# Drops
signal drop_food # Arg 1: array of sprites # Arg 2: Position
signal drop_health # Arg 1: Position
signal drop_coins # Arg 1: amount to drop (bounty) # Arg 2: Position
signal new_vfx  #arg 1: String reference to VX (PATH!! - drag theVFX scene from the FileSystem) # Arg 2: global_position
signal player_scored #Arg 1:amount, arg 2: Position DOES give the player a score automatically
# tutorial
signal plant_hunger_bar_filled # no parameters



