extends Node2D

var color = Color.WHITE
var transparent_color = Color(1.0, 1.0, 1.0, 0.7)
var line_width = 1.0
var width = 150.0

var degrees = 50.0
var degrees_range = 40.0

func _ready() -> void:
	var first_parts = _print_degrees(50.0)
	print(_get_points_on_line(50.0, first_parts))
	for i in range(5):
		var line_degrees = degrees + (i * 5.0)
		var parts = _print_degrees(degrees + (i * 5.0))
		print(_get_points_on_line(line_degrees, parts))


func _process(_delta: float) -> void:
	degrees += randf_range(0.1, 0.3)
	queue_redraw()


func _print_degrees(center_degrees: float) -> Array[float]:
	var first_digit = fmod(center_degrees, 10.0)
	var begin_degrees
	var steps
	if first_digit > 0.1:
		begin_degrees = center_degrees - (10.0 + first_digit)
		steps = 4
	else:
		begin_degrees = roundf(center_degrees - 20.0)
		steps = 5
	var parts = []
	for i in range(steps):
		parts.append(begin_degrees + (i * 10.0))
	return parts


func _get_points_on_line(center_degrees: float, parts: Array[float]) -> Array[float]:
	var points = []
	for part in parts:
		var x: float
		var diff = part - center_degrees
		if diff < 0.01:
			x = diff / -(degrees_range / 2.0) * -width
		elif diff > 0.01:
			x = diff / (degrees_range / 2.0) * width
		else:
			x = 0.0
		points.append(x)
	return points


func _draw() -> void:
	draw_line(Vector2(-width, 0), Vector2(width, 0), color, line_width, false)
	var points = _get_points_on_line(degrees, _print_degrees(degrees))
	for point in points:
		draw_line(Vector2(point, 0.0), Vector2(point, -5.0), color, line_width, false)
