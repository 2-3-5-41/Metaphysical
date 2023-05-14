extends MeshInstance3D
class_name CurveLineMesh

@export var segments : int = 16
@export var curve: Curve3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = ImmediateMesh.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	for s in segments:
		var next = s + 1
		var path_sample = curve.sample(0, s / float(segments))
		var path_sample_next = curve.sample(0, next / float(segments))

		mesh.surface_add_vertex(path_sample)
		mesh.surface_add_vertex(path_sample_next)

	mesh.surface_end()
