extends CanvasLayer

@onready var original_spread = $chromatic/ColorRect.material.get_shader_parameter("spread")
@onready var original_smear = $"VHS ColorBleed/ColorRect".material.get_shader_parameter("smear")


func _ready():
	GameEvents.player_executed.connect(on_player_execute)


func _process(delta):
	var spread = $chromatic/ColorRect.material.get_shader_parameter("spread")
	if spread > original_spread:
		var new_spread = spread-delta
		spread = new_spread
		$chromatic/ColorRect.material.set_shader_parameter("spread", spread)
	
	var smear = $"VHS ColorBleed/ColorRect".material.get_shader_parameter("smear")
	if smear > original_smear:
		var new_smear = smear-delta
		smear = new_smear
		$"VHS ColorBleed/ColorRect".material.set_shader_parameter("smear", smear)


func on_player_execute():
	$chromatic/ColorRect.material.set_shader_parameter("spread", 0.1)
	$"VHS ColorBleed/ColorRect".material.set_shader_parameter("smear", 1.0)
