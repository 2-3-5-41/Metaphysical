extends Node3D
class_name Gui3D

@export var gui: PackedScene
@export var world_scale: float = 1

@onready var viewport: SubViewport = $SubViewport
@onready var display: MeshInstance3D = $MeshInstance3D
@onready var collider: CollisionShape3D = $GUIBody3D/CollisionShape3D

var resolution: Vector2i: set = set_resolution
var aspect: Vector2

var _update: bool
var _old_scale: float

func set_resolution(size: Vector2i) -> void:
	resolution = size
	_update_aspect(size)

func set_world_scale(scale: float) -> void:
	world_scale = scale
	_old_scale = scale
	_update_aspect(resolution)

func _update_aspect(resolution: Vector2i) -> void:
	aspect = Vector2(float(resolution.x) / float(resolution.y), 1) * world_scale
	print(aspect)
	_update = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_resolution(viewport.get_size())
	viewport.call_deferred("add_child", gui.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if viewport.get_size() != resolution && !_update:
		set_resolution(viewport.get_size())
		_update = true

	if world_scale != _old_scale:
		set_world_scale(world_scale)

	_update_3d_gui()

func _update_3d_gui() -> void:
	if !_update: return
	display.get_mesh().set_size(aspect)
	collider.get_shape().set_size(Vector3(aspect.x, aspect.y, 0.01))
	_update = false
