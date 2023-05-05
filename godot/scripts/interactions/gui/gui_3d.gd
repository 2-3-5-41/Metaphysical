@tool
extends StaticBody3D
class_name GUI3D

@export var world_scale: float = 1
@export var gui: PackedScene
@onready var viewport: SubViewport = $SubViewport
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var body: CollisionShape3D = $CollisionShape3D

var _resolution: Vector2
var _aspect_ratio: Vector2
var _prev_scale: float = 1

func _ready():
	var instance: Node = gui.instantiate()
	if viewport:
		viewport.call_deferred("add_child", instance)

func _process(_delta):
	if _resolution != Vector2(viewport.get_size()):
		set_resolution(Vector2(viewport.get_size()))

	if world_scale != _prev_scale:
		_update_aspect()
		_prev_scale = world_scale

func set_resolution(res: Vector2):
	_resolution = res

	if viewport.get_size() != Vector2i(res):
		viewport.set_size(Vector2i(res))

	_update_aspect()

func set_world_scale(value: float):
	world_scale = value
	_update_aspect()

func _update_aspect():
	var ratio = _resolution.x / _resolution.y
	_aspect_ratio = Vector2(ratio, 1) * world_scale
	_update_3d_gui()

func _update_3d_gui():
	mesh.get_mesh().set_size(_aspect_ratio)
	body.get_shape().set_size(Vector3(_aspect_ratio.x, _aspect_ratio.y, 0.01))

# Convert intersection point to screen coordinate
func _global_to_viewport(p_at):
	var t = body.global_transform
	var at = t.inverse() * p_at

	# Convert to screen space
	at.x = ((at.x / _aspect_ratio.x) + 0.5) * _resolution.x
	at.y = (0.5 - (at.y / _aspect_ratio.y)) * _resolution.y

	return Vector2(at.x, at.y)

#----------------------------------------
# UI Interaction functions
#----------------------------------------
func _virtual_pointer_moved(from, to):
	var local_from = _global_to_viewport(from)
	var local_to = _global_to_viewport(to)

	# Let's mimic a mouse
	var event = InputEventMouseMotion.new()
	event.set_position(local_to)
	event.set_global_position(local_to)
	event.set_relative(local_to - local_from) # should this be scaled/warped?
	event.set_button_mask(0)
	event.set_pressure(0)

	if viewport:
		viewport.push_input(event)

func _virtual_pointer_click(pos: Vector3):
	var at = _global_to_viewport(pos)

	# Let's mimic a mouse
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(true)
	event.set_position(at)
	event.set_global_position(at)
	event.set_button_mask(1)

	if viewport:
		viewport.push_input(event)

func _virtual_pointer_release(pos: Vector3):
	var at = _global_to_viewport(pos)

	# Let's mimic a mouse
	var event = InputEventMouseButton.new()
	event.set_button_index(1)
	event.set_pressed(false)
	event.set_position(at)
	event.set_global_position(at)
	event.set_button_mask(0)

	if viewport:
		viewport.push_input(event) # Causes debug error?
