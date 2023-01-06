extends Node2D

var color = Color.WHITE
var transparent_color = Color(1.0, 1.0, 1.0, 0.7)
var line_width = 1.0
var width = 150.0

var degrees = 0.0
var degrees_range = 40.0

@onready var hud = get_owner()

func _process(_delta: float) -> void:
	if degrees != hud.y_rotation:
		degrees = hud.y_rotation
		queue_redraw()

# Get the range of 10 degree increments around a center degree
func degree_range(center_degrees: float) -> Array[float]:
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

# Get the x-values of a line that starts from [-150,150]
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
	var points = _get_points_on_line(degrees, degree_range(degrees))
	for point in points:
		draw_line(Vector2(point, 0.0), Vector2(point, 5.0), color, line_width, false)
