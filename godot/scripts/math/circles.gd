class_name Circles

## Alignment of a circle
enum CircleAlign {
	X,
	Y,
	Z
}

static func get_point_on_circle(radius: float, degree: float, alignment: CircleAlign) -> Vector3:
	var circle : Vector3 = Vector3()

	match alignment:
		CircleAlign.X:
			circle.x = 0
			circle.y = cos(deg_to_rad(degree))
			circle.z = sin(deg_to_rad(degree))
		CircleAlign.Y:
			circle.x = cos(deg_to_rad(degree))
			circle.y = 0
			circle.z = sin(deg_to_rad(degree))
		CircleAlign.Z:
			circle.x = cos(deg_to_rad(degree))
			circle.y = sin(deg_to_rad(degree))
			circle.z = 0
		_: return Vector3()

	return circle * radius

static func get_point_on_circle_2d(radius: float, degree: float) -> Vector2:
	var circle : Vector2 = Vector2()

	circle.x = cos(deg_to_rad(degree))
	circle.y = sin(deg_to_rad(degree))

	return circle * radius
