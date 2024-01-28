extends Node2D

@onready var reel_1 := $reel1
@onready var reel_2 := $reel2
@onready var reel_3 := $reel3

var target_positions = [0, 0, 0]
var current_velocities = [10, 10, 10]  # Start with a high speed
var spinning = [false, false, false]

const DECELERATION = 20  # Adjust the rate of deceleration
const MIN_SPEED = 50  # Minimum speed before stopping
const REEL_HEIGHT = 48.0


func _ready():
	GameEvents.slots_activated.connect(_on_slots_activated)
	z_index = SortLayer.FOREGROUND

func _process(delta):
	for i in range(3):
		var reel = get_node_or_null("reel" + str(i + 1))
		if reel == null or not spinning[i]:
			continue
		
		var distance = target_positions[i] - reel.region_rect.position.y

		current_velocities[i] = max(current_velocities[i] - DECELERATION * delta, MIN_SPEED)

		reel.region_rect.position.y += current_velocities[i] * delta 
		

		if abs(distance) < current_velocities[i] * delta:
			reel.region_rect.position.y = target_positions[i]
			current_velocities[i] = 0
			spinning[i] = false

func _on_slots_activated(results: Array):
	spinning = [false, false, false]
	for i in range(3):
		var reel = get_node_or_null("reel" + str(i + 1))
		reel.region_rect.position.y = fmod(reel.region_rect.position.y, REEL_HEIGHT)
		target_positions[i] = float(results[i] * 16) * 5.0
		spinning[i] = true
		print("Target position for reel", i, "set to:", target_positions[i])
