extends Marker2D

var torch_charges_last_frame := 0
var current_charges := 3
var cutscene_running := false

func _ready() -> void:
	_on_charge_amount_changed(owner.torch_charges, owner.max_torch_charges)
	GameEvents.charge_amount_changed.connect(_on_charge_amount_changed)
	GameEvents.cutscene_started.connect(_on_cutscene_start)
	GameEvents.cutscene_ended.connect(_on_cutscene_end)
	visible = false


func _process(delta):
	if current_charges == 0:
		$Alert.visible = true
	else:
		$Alert.visible = false
	if owner.facing == Enums.Facing.LEFT:
		position = Vector2(15, -20)
	else:
		position = Vector2(-15, -20)

func _on_charge_amount_changed(torch_charges, max_torch_charges):
	current_charges = torch_charges
	if not cutscene_running and owner.has_booster_upgrade:
		if torch_charges_last_frame < torch_charges:
			SoundPlayer.play_sound("pickup_2")
		visible = true
		
		
	$TextureProgressBar.max_value = max_torch_charges
	$TextureProgressBar.value = torch_charges

	torch_charges_last_frame = torch_charges


func _on_cutscene_start() -> void:
	cutscene_running = true


func _on_cutscene_end() -> void:
	cutscene_running = false

