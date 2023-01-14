class_name Crosshair
extends Node2D

# Shared drawing variables
var color = Color.WHITE
var transparent_color = Color(1.0, 1.0, 1.0, 0.7)
var line_width = 1.0

var inner_radius := 15
var normal_outer_radius := 20
var zoomed_outer_radius = 140

var zoom_line_width = 140
var zoom_line_offset = 30


enum States { NORMAL, ZOOMED_IN }
var state = States.NORMAL
var is_animating = false
var current_outer_radius = normal_outer_radius

@onready var camera: Camera3D = get_tree().get_first_node_in_group("camera")

func _draw() -> void:
	draw_line(Vector2(-(zoom_line_offset), 0), Vector2(-(zoom_line_width + zoom_line_offset), 0), transparent_color, line_width, false)
	draw_line(Vector2((zoom_line_offset), 0), Vector2((zoom_line_width + zoom_line_offset), 0), transparent_color, line_width, false)
	draw_line(Vector2(0, -inner_radius), Vector2(0, -inner_radius - 10), color, line_width, false)
	_draw_circle_arc(inner_radius)
	_draw_circle_arc(current_outer_radius)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_animating:
		queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if is_animating:
		return
	if event is InputEventMouseButton:
		if state == States.NORMAL and event.button_index == MOUSE_BUTTON_WHEEL_UP and event.is_pressed():
			_resize_outer(zoomed_outer_radius, 25.0, States.ZOOMED_IN)
		elif state == States.ZOOMED_IN and event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.is_pressed():
			_resize_outer(normal_outer_radius, 75.0, States.NORMAL)


func _draw_circle_arc(radius: float) -> void:
	var center = Vector2(0, 0)
	var start_angle = 0
	var end_angle = TAU
	var point_count = 32
	var antialiased = false
	draw_arc(center, radius, start_angle, end_angle, point_count, color, line_width, antialiased)


func _resize_outer(radius: float, fov: float, new_state: States) -> void:
	is_animating = true
	var easing = Tween.EASE_OUT if new_state == States.ZOOMED_IN else Tween.EASE_IN
	var tween = create_tween()
	tween.tween_property(self, "current_outer_radius", radius, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(easing)
	tween.tween_callback(func():
		state = new_state
		is_animating = false
	)
	tween.play()
	var camera_tween = create_tween()
	camera_tween.tween_property(camera, "fov", fov, 0.5)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(easing)
	camera_tween.play()
