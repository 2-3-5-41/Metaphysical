extends Node

var _active_laser: GuiLaserComponent
var _active_gui: GuiBody3D

func on_entered_gui(gui: GuiBody3D) -> void:
	_active_gui = gui

func on_exited_gui() -> void:
	_active_gui = null

func handle_laser_input_pressed(laser: GuiLaserComponent, point: Vector3) -> void:
	if !_active_gui: return
	if _active_laser != laser: _active_laser = laser
	_active_gui._virtual_pointer_click(point)

func handle_laser_input_released(point: Vector3) -> void:
	if !_active_gui: return
	_active_gui._virtual_pointer_release(point)

func handle_laser_moved(laser: GuiLaserComponent, then: Vector3, now: Vector3) -> void:
	if !_active_gui: return
	if laser != _active_laser: return
	_active_gui._virtual_pointer_moved(then, now)
