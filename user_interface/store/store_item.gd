extends Control


@export var cost: int = 20
@export var img: Texture
@export var description: String

func _ready():
	$Button.button_down.connect(_on_button_pressed)
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/MarginContainer/Label.text = description
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/TextureRect.texture = img
	$Button.text = str("BUY " + str(cost))

func _on_button_pressed() -> void:
	var current_cash = SaveManager.load_item("money")
	if current_cash >= cost:
		current_cash -= cost
		SaveManager.save_item("money", current_cash)
		_buy_item()
	else:
		_cannot_buy()


func _buy_item() -> void:
	print_debug("bought_it")
	pass

func _cannot_buy() -> void:
	$AnimationPlayer.play("cant_buy")

