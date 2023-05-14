extends StaticBody3D
class_name GuiBody3D

@onready var gui3d: Gui3D = $".."

func global_to_local(point: Vector3) -> Vector2:
	var t = $CollisionShape3D.global_transform
	var local = t.inverse() * point
	local.x = ((local.x / gui3d.aspect.x) + 0.5) * gui3d.resolution.x
	local.y = (0.5 - (local.y / gui3d.aspect.y)) * gui3d.resolution.y
	return Vector2(local.x, local.y)

func _virtual_pointer_moved(from: Vector3, to: Vector3):
	var local_from = global_to_local(from)
	var local_to = global_to_local(to)

	# Let's mimic a mouse
	var event = InputEventMouseMotion.new()
	event.set_position(local_to)
	event.set_global_position(local_to)
	event.set_relative(local_to - local_from) # should this be scaled/warped?
	event.set_pressure(0)

	if gui3d.viewport:
		gui3d.viewport.push_input(event)

func _virtual_pointer_click(pos: Vector3):
	var at = global_to_local(pos)

	# Let's mimic a mouse
	var event = InputEventMouseButton.new()
	event.set_button_index(MOUSE_BUTTON_LEFT)
	event.set_pressed(true)
	event.set_position(at)
	event.set_global_position(at)
	event.set_button_mask(MOUSE_BUTTON_MASK_LEFT)

	if gui3d.viewport:
		gui3d.viewport.push_input(event)

func _virtual_pointer_release(pos: Vector3):
	var at = global_to_local(pos)

	# Let's mimic a mouse
	var event = InputEventMouseButton.new()
	event.set_button_index(MOUSE_BUTTON_LEFT)
	event.set_pressed(false)
	event.set_position(at)
	event.set_global_position(at)
	event.set_button_mask(MOUSE_BUTTON_MASK_LEFT)

	if gui3d.viewport:
		gui3d.viewport.push_input(event)
