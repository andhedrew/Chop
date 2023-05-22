extends Control

@export var cost: int = 20
@export var img: Texture
@export var description: String
@export_enum("buy_health", "upgrade_bag_size", "buy_booster", "upgrade_booster_charges") var buy_function: String

var is_active := true

func _ready():
	$Button.button_down.connect(_on_button_pressed)
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/MarginContainer/Label.text = description
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/TextureRect.texture = img
	$Button.text = str("BUY: " + str(cost))

func _on_button_pressed() -> void:
	var current_cash = SaveManager.load_item("money")
	if current_cash >= cost:
		current_cash -= cost
		SaveManager.save_item("money", current_cash)
		_buy_item()
	else:
		_cannot_buy()

func _buy_item() -> void:
	call(buy_function)

func _cannot_buy() -> void:
	$AnimationPlayer.play("cant_buy")

func buy_health() -> void:
	print_debug("health bouthgaeg")

func upgrade_bag_size() -> void:
	print_debug("hupgrab bbough")

func buy_booster() -> void:
	pass

func upgrade_booster_charges() -> void:
	pass
