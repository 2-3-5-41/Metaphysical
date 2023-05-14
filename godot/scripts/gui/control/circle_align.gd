@tool
extends Container
class_name CircleAlignContainer

@export var radius: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var children: Array = get_children()
	var count: int = get_child_count()
	var i: int = 0
	for child in children:
		var point_on_circle: Vector2 = Circles.get_point_on_circle_2d(radius, 360 * i / count)
		point_on_circle.y = -point_on_circle.y
		child.position = point_on_circle
		i += 1
