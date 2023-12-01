extends Node2D


@export var no_charge_booster := false

func _ready():
	$Booster.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body is Player:
		body.has_booster_upgrade = true
		if no_charge_booster:
			body.max_torch_charges = 3
			body.torch_charges = 0
			GameEvents.charge_amount_changed.emit(0, 3)
			body.automatic_recharge = false
		queue_free()
