extends MeshInstance3D
class_name TestImmediateMesh

@export var detail: int = 5
@export var segments: int = 4
@export var radius: float = 1
@export var curve: Curve3D

var sphers : Array

func _ready() -> void:
	mesh = ImmediateMesh.new()

	for s in segments:
		for i in detail:
			var sphere = MeshInstance3D.new()
			var sphere_mesh = SphereMesh.new()
			call_deferred("add_child", sphere)

			sphere.set_mesh(sphere_mesh)
			sphere.scale = Vector3(.1,.1,.1)
			sphers.append(sphere)

func _process(_delta: float) -> void:
	for s in segments:
		for i in sphers:
			var index: int = 0
			i.position = curve.sample(0, s / float(segments)) + Circles.get_point_on_circle(radius, (index / float(detail))*360, Circles.CircleAlign.Z)
			index += 1

#func _process(_delta: float) -> void:
#	mesh.clear_surfaces()
#	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
#
#	for i in detail:
#		var point : Vector3 = Circles.get_point_on_circle(1, (i / float(detail)) * 360, Circles.CircleAlign.Z)
#		mesh.surface_set_normal(Vector3.FORWARD)
#		mesh.surface_set_uv(Vector2(0,0))
#		mesh.surface_add_vertex(point)
#
#	mesh.surface_end()
