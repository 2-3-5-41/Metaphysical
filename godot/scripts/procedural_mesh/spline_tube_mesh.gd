extends MeshInstance3D
class_name SplineTubeMesh

@onready var laser :XRLaser = $".."

@export var radius : float = 0.05
@export var vertecies : int = 5
@export var segments : int = 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh = ImmediateMesh.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	# TODO: Figure out how to generate a tube with PRIMITIVE_TRIANGLE_STRIP

	mesh.surface_end()
