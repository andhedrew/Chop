extends State


func _ready():
	GameEvents.start_spider_chase.connect(_on_start)
	

func _on_start():
	state_machine.transition_to("Walk")
