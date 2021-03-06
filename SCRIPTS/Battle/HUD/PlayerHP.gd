tool
extends Range

# Export values
export(int) var thickness = 20 setget set_thickness

export(Color, RGB) var color = Color(0, 1, 0) setget set_color

# Constants
const BG_COLOR = Color(0.2, 0.2, 0.2)
const MAX_ARC_VALUE = 100

# "Private" members

########################
### Export functions ###
########################
# Sets colors
func set_color(value):
	color = value
	update()

# Sets thickness of the bar
func set_thickness(value):
	thickness = value
	update()

######################
### Core functions ###
######################
# Overloading functions
func _draw():
	# Let us draw this whole thing from scratch
	var radius = (int(min(get_size().x, get_size().y)) >> 1)
	var center = get_size() * 0.5

	# Draw background, then progress
	_draw_round_bar(center, radius, BG_COLOR, get_max())
	_draw_round_bar(center, radius, color, get_value())

# Draws our bar
func _draw_round_bar(center, radius, color, value):
	var arc_value = max(min(value, MAX_ARC_VALUE), 0)
	var rect_pos = draw_circle_arc(center, radius, 270, color, arc_value)

	if value > MAX_ARC_VALUE:
		var rest_value = value - MAX_ARC_VALUE if value >= MAX_ARC_VALUE else 0
		rect_pos.y -= thickness
		draw_rect(Rect2(rect_pos, Vector2(-rest_value, thickness)), color)

	return rect_pos

########################
### Helper functions ###
########################
func draw_circle_arc(center, radius, maximum, color, amount):
	maximum = max(min(maximum, 360), 0)
	var angle_from = -180
	var angle_to = maximum * amount / MAX_ARC_VALUE + angle_from

	if angle_from >= angle_to:
		return

	var position
	var nb_points = 32
	var points = Vector2Array()

	var angle = (angle_to - angle_from)/nb_points
	points.push_back(center)
	for i in range(nb_points+1):
		var angle_point = angle_from + i * angle
		position = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
		points.push_back(position)

	draw_colored_polygon(points, color)
	return position
