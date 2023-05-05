extends Node
class_name GUIEventSystem

var _active_laser: XRLaser = null
var _active_gui: GUI3D = null

func _handle_laser_input_pressed(laser: XRLaser, point: Vector3):
	if !_active_gui:
		return

	if _active_laser != laser:
		_active_laser = laser

	_active_gui._virtual_pointer_click(point)
	print("Laser input pressed: ", laser, " ", point)

func _handle_laser_input_released(_laser: XRLaser, point: Vector3):
	if !_active_gui:
		return

	_active_gui._virtual_pointer_release(point)
	print("Laser input pressed: ", _laser, " ", point)

func _handle_laser_moved(laser: XRLaser, point: Vector3, prev_point: Vector3):
	if !_active_gui:
		return

	if laser != _active_laser:
		return

	_active_gui._virtual_pointer_moved(prev_point, point)
	print("Laser input pressed: ", laser, " ", point, " ", prev_point)

func _on_entered_gui(_laser: XRLaser, gui: GUI3D):
	_active_gui = gui
	print(_laser, " Entered GUI ", gui)

func _on_exited_gui(_laser: XRLaser):
	_active_gui = null
	print(_laser, " Exited GUI")
