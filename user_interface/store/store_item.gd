extends Control

var cost: int = 20
@export var img: Texture
@export var header: String
@export var description: String
@export_enum("buy_health", "get_more_lives", "buy_booster", "upgrade_booster_charges", "buy_value") var buy_function: String

@export var one_time_purchase : bool = false


var is_active := true
var just_bought := false
var is_hovering := false

func _ready():
	$AnimationPlayer.play("RESET")
	$Button.pressed.connect(_on_button_pressed)
	
	
	# Setup
	match buy_function:
		"buy_health": 
			var current_health = SaveManager.load_item("health")
			cost = current_health * 5
		"get_more_lives": 
			cost = 100
		"buy_booster": 
			var booster_got = SaveManager.load_item("booster_upgrade")
			print_debug(str(booster_got))
			if booster_got:
				buy_function = "upgrade_booster_charges"
				img = load("res://user_interface/torch_charges/charge.png")
				header = "Extra Boost"
				description = "One more boost before it kicks the bucket."
				var booster_charge_number = SaveManager.load_item("booster_charges")
				cost = 7 * booster_charge_number
			else:
				cost = 25
		"upgrade_booster_charges": 
			var booster_charge_number = SaveManager.load_item("booster_charges")
			cost = 7 * booster_charge_number
		"buy_value":
			cost = 10
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/TextureRect.texture = img
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/Heading.text = header
	$ColorRect/MarginContainer/ColorRect/MarginContainer/Panel/Description.text = description
	
	set_button_text()




func set_button_text() -> void:
	$Button.text = str("Buy for " + str(cost) + "¢")


func _on_button_pressed() -> void:
	if not just_bought:
		SoundPlayer.play_sound("hover_button")
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
	SoundPlayer.play_sound("buy")
	call(buy_function)



func _cannot_buy() -> void:
	SoundPlayer.play_sound("uhuh")
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


func get_more_lives() -> void:
	var lives = SaveManager.load_item("lives")
	lives += 1
	SaveManager.save_item("lives", lives)
	await get_tree().create_timer(1.5).timeout
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


func buy_value() -> void:
	GameEvents.player_scored.emit(10, global_position)
	var value = SaveManager.load_item("score")
	SaveManager.save_item("score", value+10)
	await get_tree().create_timer(1.5).timeout
	set_button_text()
	just_bought = false
	
