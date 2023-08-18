
extends State


func enter(_msg := {}) -> void:
	var hand := preload("res://characters/enemy/grabnimonie/grabnimonie_hand.tscn").instantiate()
	hand.position.y = owner.position.y
	hand.position.x = _msg.x
	
	add_child(hand)
	hand.z_index = SortLayer.FOREGROUND
	await get_tree().create_timer(1.0).timeout
	state_machine.transition_to("Idle")

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass


#func drop() -> void:
