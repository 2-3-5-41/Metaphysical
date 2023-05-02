extends Node
class_name GUIEventSystem

var _active_laser: GUILaser = null
var _active_gui: GUI3D = null


func _handle_laser_input_pressed(laser: GUILaser, point: Vector3):
	if !_active_gui:
		return
	
	if _active_laser != laser:
		_active_laser = laser
	
	_active_gui._virtual_pointer_click(point)

func _handle_laser_input_released(_laser: GUILaser, point: Vector3):
	if !_active_gui:
		return
	
	_active_gui._virtual_pointer_release(point)

func _handle_laser_moved(laser: GUILaser, point: Vector3, prev_point: Vector3):
	if !_active_gui:
		return
	
	if laser != _active_laser:
		return
	
	_active_gui._virtual_pointer_moved(prev_point, point)

func _on_entered_gui(gui: GUI3D):
	_active_gui = gui

func _on_exited_gui():
	_active_gui = null