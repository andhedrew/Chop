extends State


@onready var attack_hurtbox := $"../../Pivot/AttackHurtbox"
@onready var attack_hitbox := $"../../Pivot/AttackHitbox"
@onready var hurtbox_collision := $"../../Pivot/AttackHurtbox/CollisionShape2D"
@onready var hitbox_collision := $"../../Pivot/AttackHitbox/CollisionShape2D"
@onready var move_amount = Vector2.ZERO # Change this to the desired move amount
var move_duration = 0.2 # Change this to the desired move duration
var hitbox_original_width
var hurtbox_original_width


func _ready():
	hitbox_original_width = hitbox_collision.shape.size.x
	hurtbox_original_width = hurtbox_collision.shape.size.x
	attack_hurtbox.area_entered.connect(on_tongue_attacked)
	hurtbox_collision.shape.size.x = 1
	hitbox_collision.shape.size.x = 1
	attack_hurtbox.monitoring = false
	attack_hitbox.monitorable = false


func enter(_msg := {}) -> void:
	SoundPlayer.play_sound("paroot_boss_spit")
	owner.animation_player.play("attack1")
	move_amount = Vector2(-70, 0)


func transition_to_move() ->void:
	state_machine.transition_to("Move")


func activate_hitboxes() -> void:
	hitbox_collision.shape.size.x = hitbox_original_width
	hurtbox_collision.shape.size.x = hurtbox_original_width
	attack_hurtbox.monitoring = true
	attack_hitbox.monitorable = true
	attack_hurtbox.position += move_amount
	attack_hitbox.position += move_amount


func deactivate_hitboxes() -> void:
	hurtbox_collision.shape.size.x = 1
	hitbox_collision.shape.size.x = 1
	attack_hurtbox.set_deferred("monitoring", false)
	attack_hitbox.set_deferred("monitorable", false)
	attack_hurtbox.position -= move_amount
	attack_hitbox.position -= move_amount


func on_tongue_attacked(_hitbox) -> void:
	state_machine.transition_to("Hurt")


func exit() -> void:
	deactivate_hitboxes()
