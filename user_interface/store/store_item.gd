extends Control

@export var cost: float = 20.0
@export var img: Texture
@export var description: String
@export_enum("buy_health", "upgrade_bag_size", "buy_booster", "upgrade_booster_charges") var buy_function: String


var is_active := true
var just_bought := false

func _ready():
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/TextureRect.texture = img
	set_button_text()
	$AnimationPlayer.play("RESET")
	SaveManager.save_item("money", 25)
	$Button.pressed.connect(_on_button_pressed)


func set_button_text() -> void:
	$Button.text = str("Buy for " + str(cost) + "¢")
	


func _on_button_pressed() -> void:
	if not just_bought:
		var current_cash = SaveManager.load_item("money")
		
		if current_cash >= cost:
			current_cash -= cost
			SaveManager.save_item("money", current_cash)
			$AnimationPlayer.play("bought")
			_buy_item()
			
		else:
			_cannot_buy()
		
	if not is_active:
		$Button.text = str("BOUGHT")
		$Button.disabled = true


func _buy_item() -> void:
	just_bought = true
	call(buy_function)


func _cannot_buy() -> void:
	$AnimationPlayer.play("cant_buy")


func buy_health() -> void:
	print_debug("health bouthgaeg")
	cost *= 0.3
	cost = round(cost)
	await get_tree().create_timer(1.5).timeout
	set_button_text()
	just_bought = false


func upgrade_bag_size() -> void:
	print_debug("hupgrab bbough")
	cost *= 0.3
	cost = round(cost)
	await get_tree().create_timer(1.5).timeout
	set_button_text()
	just_bought = false


func buy_booster() -> void:
	is_active = false
	print_debug("boggt buster")


func upgrade_booster_charges() -> void:
	print_debug("oppgrudded buster sharjez")
	cost *= 0.3
	cost = round(cost)
	await get_tree().create_timer(1.5).timeout
	set_button_text()
	just_bought = false

