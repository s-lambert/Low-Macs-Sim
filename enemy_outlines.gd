class_name EnemyOutlines
extends Node2D

@onready var camera = get_viewport().get_camera_3d()

var outlines = {}

func _process(delta: float) -> void:
	outlines = {}
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var position_2d := camera.unproject_position(enemy.global_position)
		if position_2d.x > 0 and position_2d.x < 640 and position_2d.y > 0 and position_2d.y < 480:
			outlines[enemy] = { 
				"position_2d": position_2d,
				"distance_from_camera": (enemy.global_position - camera.global_position).length()
			}
	queue_redraw()

 
func _draw() -> void:
	for enemy in outlines:
		var position_2d: Vector2 = outlines[enemy].position_2d
		var rectangle_size = Vector2(50.0, 35.0) * (50.0 / outlines[enemy].distance_from_camera)
		draw_rect(Rect2(position_2d - (rectangle_size / 2), rectangle_size), Color.RED, false, 1.0)
