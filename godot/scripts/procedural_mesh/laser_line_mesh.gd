extends CurveLineMesh
class_name LaserLineMesh

func update_curve(start: Vector3, tangent: Vector3, end: Vector3) -> void:
	if start != Vector3.ZERO:
		curve.set_point_position(0, start)

	if tangent != Vector3.ZERO:
		curve.set_point_out(0, tangent)

	if end != Vector3.ZERO:
		curve.set_point_position(1, end)
