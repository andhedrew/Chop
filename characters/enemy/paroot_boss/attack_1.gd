extends State


@onready var attack_hurtbox := $"../../Pivot/AttackHurtbox"
@onready var attack_hitbox := $"../../Pivot/AttackHitbox"
@onready var move_amount = Vector2(50, 0) # Change this to the desired move amount
var move_duration = 0.2 # Change this to the desired move duration


func enter(_msg := {}) -> void:
	owner.animation_player.play("attack1")
	attack_hurtbox.area_entered.connect(on_tongue_attacked)
	move_amount = Vector2(-50, 0)


func activate_hitboxes() -> void:
	attack_hurtbox.monitoring = true
	attack_hitbox.monitorable = true
	attack_hurtbox.position += move_amount
	attack_hitbox.position += move_amount



func deactivate_hitboxes() -> void:
	attack_hurtbox.monitoring = false
	attack_hitbox.monitorable = false
	attack_hurtbox.position -= move_amount
	attack_hitbox.position -= move_amount
	state_machine.transition_to("Move")


func on_tongue_attacked(hitbox) -> void:
	if hitbox.execute:
		print_debug("tongue_takes_damage")
