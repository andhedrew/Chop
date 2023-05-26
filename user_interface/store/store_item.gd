extends Control

var cost: int = 20
@export var img: Texture
@export var header: String
@export var description: String
@export_enum("buy_health", "upgrade_bag_size", "buy_booster", "upgrade_booster_charges") var buy_function: String


var is_active := true
var just_bought := false

func _ready():
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/TextureRect.texture = img
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/Heading.text = header
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/Description.text = description
	
	$AnimationPlayer.play("RESET")
	$Button.pressed.connect(_on_button_pressed)
	
	# Setup
	match buy_function:
		"buy_health": 
			var current_health = SaveManager.load_item("health")
			cost = current_health * 5
		"upgrade_bag_size": 
			var bag_size = SaveManager.load_item("bag_size")
			cost = bag_size
		"buy_booster": 
			var booster_got = SaveManager.load_item("booster_upgrade")
			cost = 25
			if booster_got:
				is_active = false
		"upgrade_booster_charges": 
			var booster_charge_number = SaveManager.load_item("booster_charges")
			cost = 7 * booster_charge_number
	
	set_button_text()


func set_button_text() -> void:
	$Button.text = str("Buy for " + str(cost) + "¢")


func _on_button_pressed() -> void:
	if not just_bought:
		var current_cash = SaveManager.load_item("money")
		
		if current_cash >= cost:
			current_cash -= cost
			SaveManager.save_item("money", current_cash)
			GameEvents.player_money_changed.emit(current_cash)
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
	var current_health = SaveManager.load_item("health")
	current_health += 2
	GameEvents.player_health_changed.emit(current_health, current_health)
	SaveManager.save_item("health", current_health)
	await get_tree().create_timer(1.5).timeout
	cost = current_health * 5
	set_button_text()
	just_bought = false


func upgrade_bag_size() -> void:
	var bag_size = SaveManager.load_item("bag_size")
	bag_size += 5
	SaveManager.save_item("bag_size", bag_size)
	await get_tree().create_timer(1.5).timeout
	cost = bag_size
	set_button_text()
	just_bought = false
	


func buy_booster() -> void:
	is_active = false
	SaveManager.save_item("booster_upgrade", true)


func upgrade_booster_charges() -> void:
	var booster_charge_number = SaveManager.load_item("booster_charges")
	booster_charge_number += 1
	SaveManager.save_item("booster_charges", booster_charge_number)
	await get_tree().create_timer(1.5).timeout
	cost = 7 * booster_charge_number
	set_button_text()
	just_bought = false

