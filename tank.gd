class_name Tank
extends CharacterBody3D

enum States { MOVING, AIMING, FIRING }

const SPEED = 8.0

var state

@onready var player = get_tree().get_first_node_in_group("player")
@onready var turret = $%Turret

func _ready() -> void:
	state = States.MOVING

func _process(delta: float) -> void:
	var turret_position_2d = Vector2(turret.global_position.x, turret.global_position.z)
	var player_position_2d = Vector2(player.global_position.x, player.global_position.z)
	var direction = turret_position_2d - player_position_2d
	turret.rotation.y = atan2(direction.x, direction.y) + PI / 2
	move_and_slide()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	await get_tree().create_timer(2.0).timeout
	return
	state = States.AIMING
	var angle_to_player = turret.global_position.angle_to(player.global_position)
	print(angle_to_player)
	var rotated_to_player = turret.rotation.rotated(Vector3.UP, angle_to_player)
	print(rotated_to_player)
	var tween = create_tween()
	tween.tween_property(turret, "rotation", rotated_to_player, 1.0)
	tween.play()
